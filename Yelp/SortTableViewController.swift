final class SortTableViewController: ExpandableUITableViewController<Sort, SortTableViewCell> {
    
    var filters: Filters
    
    init(elements: [Sort], cellId: String, section: Int, filters: Filters) {
        self.filters = filters
        super.init(elements: elements, section: section, cellId: cellId)
    }
    
    override func selected() -> Sort {
        return filters.sort
    }
    
    override func sort() {
        elements.sort(by: { (s1: Sort, s2: Sort) in
            filters.sort == s1 || filters.sort != s2 && s1.rawValue < s2.rawValue
        })
    }
    
    override func select(value: Sort) {
        filters.sort = value
    }
}
