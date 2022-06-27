//
//  TestViewController.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/25.
//

import UIKit
import SwiftEntryKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func testButtonAction(_ sender: Any) {
        NotificationBanner.show(title: "Notification title", body: "Notification body", image: UIImage(named: "dog2")!)
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
