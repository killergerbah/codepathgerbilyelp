import UIKit

protocol ExpandableTableViewCell {
    associatedtype Filter
    
    var setting: Filter { get }
    
    func refresh(with filter: Filter, expanded: Bool, selected: Bool)
}
