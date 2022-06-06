//
//  SettingTableViewCell.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//
import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var releaseNotificationSwitch: UISwitch!
    @IBOutlet weak var releaseNotificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //releaseNotificationSwitch.isEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // スイッチがオンになった時
    @IBAction func releaseNotifcationSwitchAction(_ sender: Any) {
        // 画面遷移する
//        performSegue(withIdentifier: "toSettingDetailController", sender: nil)
        
    }
}
