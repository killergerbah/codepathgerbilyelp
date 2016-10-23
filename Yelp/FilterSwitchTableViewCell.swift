import UIKit

protocol FilterSwitchTableViewCellDelegate: class {
    
    func filterSwitchCell(_ cell: FilterSwitchTableViewCell, didChangeValue value: Bool)
}

final class FilterSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    
    weak var delegate: FilterSwitchTableViewCellDelegate?
    weak var category: Category!

    func refresh(with category: Category, enabled: Bool) {
        self.category = category
        
        settingLabel.text = category.title
        settingSwitch.setOn(enabled, animated: false)
    }
    
    @IBAction func onValueChanged(_ sender: AnyObject) {
        delegate?.filterSwitchCell(self, didChangeValue: settingSwitch.isOn)
    }
}
