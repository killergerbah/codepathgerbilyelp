import UIKit

protocol FilterViewControllerDelegate: class {
    
    func filtersViewController(_ filtersViewController: FilterViewController, didUpdateFilters filters: Filters)
}

final class FilterViewController: UIViewController {

    private static let minShownCategories = 3
    
    @IBOutlet weak var filterTableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate?
    
    var filters: Filters!
    
    fileprivate var categories: [Category] = []
    
    fileprivate var distanceTableViewController: DistanceTableViewController!
    fileprivate var sortTableViewController: SortTableViewController!
    fileprivate var categoryExpanded = false
    fileprivate var categoriesSeeMoreIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        filterTableView.delegate = self
        
        distanceTableViewController  = DistanceTableViewController(elements: Distance.values, cellId: "DistanceCell", section: Section.distance.rawValue, filters: filters)
        sortTableViewController = SortTableViewController(elements: Sort.values, cellId: "SortCell", section: Section.sort.rawValue, filters: filters)
        
        categories = JsonCategoryFactory.instance.get(category: "restaurants")
        categoriesSeeMoreIndex = max(filters.enabledCategories.count, FilterViewController.minShownCategories)
        sortCategories()
        
        filterTableView.reloadData()
    }
    
    fileprivate func sortCategories() {
        categories.sort(by: { (c1: Category, c2: Category) in
            if filters.get(category: c1) {
                if (filters.get(category: c2)) {
                    return c1.title < c2.title
                }
                
                return true
            }
            
            return c1.title < c2.title
        })
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true)
        delegate?.filtersViewController(self, didUpdateFilters: filters)
    }
    
    fileprivate enum Section: Int {
        static let count = 4
        
        case deals = 0
        case distance = 1
        case sort = 2
        case category = 3
    }
}

extension FilterViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .deals:
            return 1
        case .distance:
            return distanceTableViewController.tableView(tableView, numberOfRowsInSection: section.rawValue)
        case .sort:
            return sortTableViewController.tableView(tableView, numberOfRowsInSection: section.rawValue)
        case .category:
            return categoryExpanded ? categories.count : categoriesSeeMoreIndex + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .deals:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DealSwitchCell") as? DealSwitchTableViewCell {
                cell.refresh(enabled: filters.deals)
                cell.delegate = self
                return cell
            }
        case .distance:
            return distanceTableViewController.tableView(tableView, cellForRowAt: indexPath)
        case .sort:
            return sortTableViewController.tableView(tableView, cellForRowAt: indexPath)
        case .category:
            if !categoryExpanded && indexPath.row == categoriesSeeMoreIndex,
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSeeAllCell") {
                return cell
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSwitchCell") as? FilterSwitchTableViewCell {
                let category = categories[indexPath.row]
                cell.refresh(with: category, enabled: filters.get(category: category))
                cell.delegate = self

                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.contentView.backgroundColor = UIColor(red: 211.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 355.0, alpha: 1)
            view.textLabel?.textColor = UIColor.white
            view.textLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
            view.textLabel?.textAlignment = NSTextAlignment.center
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            return nil
        }
        switch section {
        case .distance:
            return "Distance"
        case .sort:
            return "Sort By"
        case .category:
            return "Category"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch section {
        case .distance:
            distanceTableViewController.tableView(tableView, didSelectRowAt: indexPath)
            filters = distanceTableViewController.filters
        case .sort:
            sortTableViewController.tableView(tableView, didSelectRowAt: indexPath)
            filters = sortTableViewController.filters
        case .category:
            if !categoryExpanded && indexPath.row == categoriesSeeMoreIndex {
                categoryExpanded = true
                tableView.reloadSections(IndexSet(integer: section.rawValue), with: UITableViewRowAnimation.automatic)
            }
        default:
            return
        }
    }
}

extension FilterViewController: FilterSwitchTableViewCellDelegate {
    
    func filterSwitchCell(_ cell: FilterSwitchTableViewCell, didChangeValue value: Bool) {
        filters.set(category: cell.category, enabled: value)
    }
}

extension FilterViewController: DealSwitchTableViewCellDelegate {
    
    func dealSwitchCell(_ cell: DealSwitchTableViewCell) {
        filters.deals = cell.deals
    }
}
