import UIKit

final class DistanceTableViewCell: UITableViewCell, ExpandableTableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    
    private(set) var distance: Distance!
    var setting: Distance {
        return distance
    }
    
    func refresh(with distance: Distance, expanded: Bool, selected: Bool) {
        self.distance = distance
        self.distanceLabel.text = "\(distance.description)"
    }
}
