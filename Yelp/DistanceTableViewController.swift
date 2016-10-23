final class DistanceTableViewController: ExpandableUITableViewController<Distance, DistanceTableViewCell> {
    
    var filters: Filters
    
    init(elements: [Distance], cellId: String, section: Int, filters: Filters) {
        self.filters = filters
        super.init(elements: elements, section: section, cellId: cellId)
    }
    
    override func selected() -> Distance {
        return filters.distance
    }
    
    override func sort() {
        elements.sort(by: { (d1: Distance, d2: Distance) in
            filters.distance == d1 || filters.distance != d2 && d1.rawValue < d2.rawValue
        })
    }
    
    override func select(value: Distance) {
        filters.distance = value
    }
}
