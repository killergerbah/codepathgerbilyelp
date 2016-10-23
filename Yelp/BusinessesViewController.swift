//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    fileprivate var businesses: [Business]! = []
    fileprivate var filters = Filters()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.dataSource = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        search()
    }
    
    fileprivate func search() {
        guard let text = searchBar.text else {
            return
        }
        search(for: text, sort: filters.sort, categories: filters.enabledCategories, deals: filters.deals, distance: filters.distance)
    }
    
    private func search(for term: String, sort: Sort, categories: [Category], deals: Bool, distance: Distance) {
        let categoryAliases: [String]? = categories.count == 0 ? nil : categories
            .map({ (c: Category) -> String in c.alias })
        
        let radius: Int? = distance == Distance.automatic ? nil : Int(distance.meters)
        
        Business.searchWithTerm(term: term, sort: sort, categories: categoryAliases, deals: deals, radius: radius, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses ?? []
            self.businessTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nc = segue.destination as? UINavigationController,
            let vc = nc.topViewController as? FilterViewController else {
                return
        }
        
        vc.delegate = self
        vc.filters = filters
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        searchBar.resignFirstResponder()
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as? BusinessTableViewCell else {
            return BusinessTableViewCell()
        }
        
        cell.refresh(business: businesses[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension BusinessesViewController: FilterViewControllerDelegate {
    
    func filtersViewController(_ filtersViewController: FilterViewController, didUpdateFilters filters: Filters) {
        self.filters = filters
        search()
    }
    
}
