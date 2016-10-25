//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController {
    
    static let itemsPerPage = 20
    
    @IBOutlet weak var businessTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!

    fileprivate var businesses: [Business]! = []
    fileprivate var filters = Filters()
    fileprivate var loadingMore = false
    fileprivate var currentPageSize = BusinessesViewController.itemsPerPage
    fileprivate var page = 0
    fileprivate var canLoadMore: Bool {
        return currentPageSize >= BusinessesViewController.itemsPerPage
    }
    fileprivate var selected: Business?
    fileprivate var display = Display.list
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.tabBarController?.delegate = self
        updateView()
    }
    
    private func updateView() {
        switch display {
        case .list:
            businessTableView.reloadData()
        case .map:
            updateMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120

        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        switch display {
        case .list:
            mapView.isHidden = true
        case .map:
            mapView.isHidden = false
            mapView.setRegion(MKCoordinateRegionMake(CLLocation(latitude: 37.785771, longitude: -122.406165).coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        }
        
        if businesses.count == 0 {
            search()
        }
    }
    
    fileprivate func search() {
        search(for: 0)
    }
    
    fileprivate func search(for page: Int) {
        guard let text = searchBar.text else {
            return
        }
        search(for: text, sort: filters.sort, categories: filters.enabledCategories, deals: filters.deals, distance: filters.distance, page: page)
    }
    
    private func search(for term: String, sort: Sort, categories: [Category], deals: Bool, distance: Distance, page: Int) {
        let categoryAliases: [String]? = categories.count == 0 ? nil : categories
            .map({ (c: Category) -> String in c.alias })
        
        let radius: Int? = distance == Distance.automatic ? nil : Int(distance.meters)
        
        let itemsPerPage = BusinessesViewController.itemsPerPage
        if page > 0 && !canLoadMore {
            return
        }
        
        Business.searchWithTerm(term: term, sort: sort, categories: categoryAliases, deals: deals, radius: radius, limit: itemsPerPage, offset: itemsPerPage * page, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if page > self.page {
                self.businesses.append(contentsOf: businesses ?? [])
                self.loadingMore = false
            } else {
                self.businesses = businesses ?? []
            }
            
            self.loadingMore = false
            self.page = page
            self.currentPageSize = businesses == nil ? self.currentPageSize : businesses!.count
            self.selected = nil
            
            self.updateView()
        })
    }
    
    private func updateMap() {
        mapView.removeAnnotations(mapView.annotations)

        var annotations: [MKAnnotation] = []
        var selectedAnnotation: MKAnnotation?
        for business in businesses {
            if let latitude = business.latitude,
                let longitude = business.longitude {
                let annotation = MKPointAnnotation()
                annotation.title = business.name
                annotation.subtitle = business.categories
                annotation.coordinate = CLLocation(latitude: latitude, longitude: longitude).coordinate
                annotations.append(annotation)
                
                if business == self.selected {
                    selectedAnnotation = annotation
                }
            }
        }
        
        if annotations.count > 0 {
            mapView.addAnnotations(annotations)
            mapView.selectAnnotation(selectedAnnotation ?? annotations[0], animated: true)
        }
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
    
    fileprivate enum Display: Int {
        case list = 0
        case map
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tapGestureRecognizer.isEnabled = false
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapGestureRecognizer.isEnabled = true
    }
}

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canLoadMore ? businesses.count + 1 : businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if canLoadMore && indexPath.row == businesses.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell") as? LoadingTableViewCell {
            cell.animate()
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as? BusinessTableViewCell {
            cell.refresh(business: businesses[indexPath.row], index: indexPath.row)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension BusinessesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected = businesses[indexPath.row]
        
        if let tabBarController = navigationController?.tabBarController,
            let tabBarViewControllers = tabBarController.viewControllers,
            tabBarViewControllers.count >= Display.map.rawValue + 1 {
            let mapViewController = tabBarViewControllers[Display.map.rawValue]
            tabBarController.selectedViewController = mapViewController
            tabBarController.delegate?.tabBarController?(tabBarController, didSelect: mapViewController)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Adapted from the infinite scroll Codepath guide
        if (!loadingMore) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = max(scrollViewContentHeight - businessTableView.bounds.size.height * 2 , 0)
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessTableView.isDragging) {
                loadingMore = true
                search(for: page + 1)
            }
        }
    }
}

extension BusinessesViewController: FilterViewControllerDelegate {
    
    func filtersViewController(_ filtersViewController: FilterViewController, didUpdateFilters filters: Filters) {
        self.filters = filters
        search()
    }
    
}

extension BusinessesViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewController as? UINavigationController,
            let viewController = navigationController.visibleViewController as? BusinessesViewController else {
            return
        }
        if let index = tabBarController.viewControllers?.index(of: navigationController),
            let display = Display(rawValue: index) {
            viewController.display = display
            viewController.businesses = businesses
            viewController.searchBar.text = searchBar.text
            viewController.filters = filters
            viewController.selected = selected
        }
    }
}
