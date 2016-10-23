import UIKit

final class LoadingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func animate() {
        activityIndicator.startAnimating()
    }
}
