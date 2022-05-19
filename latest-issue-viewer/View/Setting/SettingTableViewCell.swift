//
//  SettingTableViewCell.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var releaseNotification_switch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
