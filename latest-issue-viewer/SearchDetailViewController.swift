//
//  SearchDetailViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//

import UIKit

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var bookImageImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    var bookTitleValue :String?
    var authorNameValue :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTitleLabel.text = bookTitleValue
        authorNameLabel.text = authorNameValue
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
