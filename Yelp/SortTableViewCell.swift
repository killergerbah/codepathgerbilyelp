import UIKit

final class SortTableViewCell: UITableViewCell, ExpandableTableViewCell {
    
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    private(set) var sort: Sort!
    var setting: Sort {
        return sort
    }

    
    func refresh(with sort: Sort, expanded: Bool, selected: Bool) {
        self.sort = sort
        sortLabel.text = "\(sort.description)"
        arrowLabel.isHidden = expanded
        checkLabel.isHidden = !expanded || !selected
    }
}
