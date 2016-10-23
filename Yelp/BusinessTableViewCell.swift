import UIKit
import AFNetworking

final class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    func refresh(business: Business, index: Int) {
        if let imageUrl = business.imageURL {
            businessImageView.setImageWith(imageUrl)
        }
        
        if let ratingImageUrl = business.ratingImageURL {
            ratingImageView.setImageWith(ratingImageUrl)
        }

        reviewsLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = business.address
        nameLabel.text = "\(index + 1). \(business.name!)"
        distanceLabel.text = business.distance
        categoriesLabel.text = business.categories
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
