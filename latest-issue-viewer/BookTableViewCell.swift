//
//  BookViewCell.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/05.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var book_title_label: UILabel!
    @IBOutlet weak var book_image_imageView: UIImageView!
    @IBOutlet weak var book_salesDate_textfield: UILabel!
            
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
