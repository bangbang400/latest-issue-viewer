//
//  FavoriteTableViewCell.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/05.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favorite_imageView: UIImageView!
    @IBOutlet weak var favoriteTitle_label: UILabel!
    @IBOutlet weak var releaseDate_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
