import Foundation

struct Filters {
    
    private var categories: [Category:Bool] = [:]

    var enabledCategories: [Category] {
        return categories.keys
            .filter({ (key: Category) -> Bool in categories[key] ?? false })
    }
    
    var deals = false
    var distance = Distance.automatic
    var sort = Sort.bestMatch
    
    init() {
    }
    
    mutating func set(category: Category, enabled: Bool) {
        categories[category] = enabled
    }
    
    func get(category: Category) -> Bool {
        return categories[category] ?? false
    }
}
