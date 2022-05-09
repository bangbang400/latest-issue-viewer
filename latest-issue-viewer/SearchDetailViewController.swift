//
//  SearchDetailViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//

import UIKit

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var test: UILabel!
    
    var testValue :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test.text = testValue
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
