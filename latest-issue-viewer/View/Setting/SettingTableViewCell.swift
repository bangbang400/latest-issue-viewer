//
//  SettingTableViewCell.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//
import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var releaseNotificationSwitch: UISwitch!
    @IBOutlet weak var settingNotifiDateLabel: UILabel!
    
    //
    var datePickerListValue:[String]?    
    
    // 通知日を設定
    var setNotifiDateValue:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //releaseNotificationSwitch.isEnabled = false
        // 設定した発売日を表示する
        settingNotifiDateLabel.text = String(setNotifiDateValue ?? 1)
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
