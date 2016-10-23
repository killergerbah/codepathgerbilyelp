import Foundation

final class Category: Hashable {
    
    let parents: [String]
    let title: String
    let alias: String
    
    var hashValue: Int {
        return title.hashValue
    }
    
    init(parents: [String], title:String, alias:String) {
        self.parents = parents
        self.title = title
        self.alias = alias
    }
}

func ==(_ left: Category, _ right: Category) -> Bool {
    return left.title == right.title
}
