import UIKit

protocol DealSwitchTableViewCellDelegate: class {
    
    func dealSwitchCell(_ cell: DealSwitchTableViewCell);
}

final class DealSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    weak var delegate: DealSwitchTableViewCellDelegate?
    
    private(set) var deals = false
    
    func refresh(enabled: Bool) {
        settingLabel.text = "Offering a Deal"
        settingSwitch.setOn(enabled, animated: false)
    }
    
    @IBAction func onValueChanged(_ sender: AnyObject) {
        deals = settingSwitch.isOn
        delegate?.dealSwitchCell(self)
    }
}
