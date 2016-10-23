import UIKit

class ExpandableUITableViewController<Filter, Cell: ExpandableTableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell.Filter == Filter, Cell: UITableViewCell {
    
    var elements: [Filter]
    private let cellId: String
    private let section: Int
    private var expanded = false
    
    init(elements: [Filter], section:Int, cellId: String) {
        self.elements = elements
        self.section = section
        self.cellId = cellId
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? Cell {
            let element = expanded ? elements[indexPath.row] : selected()
            cell.refresh(with: element, expanded: expanded, selected: indexPath.row == 0)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expanded ? elements.count : 1
    }
    
    func selected() -> Filter {
        preconditionFailure("This method must be overridden")
    }
    
    func sort() {
        preconditionFailure("This method must be overridden")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? Cell {
            select(value: cell.setting)
            expanded = !expanded
            sort()
            tableView.reloadSections(IndexSet(integer: section), with: UITableViewRowAnimation.automatic)
        }
    }
    
    func select(value: Filter) {
        preconditionFailure("This method must be overridden")
    }
}
