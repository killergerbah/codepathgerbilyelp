import Foundation
import UIKit

final class JsonCategoryFactory: CategoryFactory {
    
    static let instance = JsonCategoryFactory()
    
    private var categories: [Category] = []
    
    private init() {
    }
    
    func get(category: String) -> [Category] {
        if categories.count == 0 {
            readCategories()
        }
        
        return categories.filter({ (c: Category) -> Bool in c.parents.contains(category) })
    }
    
    private func readCategories() {
        if let path = Bundle.main.path(forResource: "Categories", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    if let categories = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        for category in categories {
                            if let category = category as? [String:AnyObject],
                                let title = category["title"] as? String,
                                let alias = category["alias"] as? String,
                                let parents = parents(from: category["parents"]) {
                                self.categories.append(Category(parents: parents, title: title, alias: alias))
                            }
                        }
                    }
            }
            catch {
                NSLog("Failed to read categories path \(path)")
            }
        }
    }
    
    private func parents(from object: AnyObject?) -> [String]? {
        guard let parentsArray = object as? NSArray else {
            return nil
        }
        
        var parents: [String] = []
        for parent in parentsArray {
            if let parent = parent as? String {
                parents.append(parent)
            }
        }
        
        return parents
    }
}
