import UIKit

final class SortTableViewCell: UITableViewCell, ExpandableTableViewCell {

    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var sortLabelChoice: UILabel!
    
    private(set) var sort: Sort!
    var setting: Sort {
        return sort
    }

    
    func refresh(with sort: Sort, expanded: Bool, selected: Bool) {
        self.sort = sort
        sortLabel.text = "\(sort.description)"
        sortLabelChoice.isHidden = true
    }
}
