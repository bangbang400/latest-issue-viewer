//
//  ViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/01.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var setting_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カスタムセルの登録
        setting_tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingTableView")
                        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingTableView", for: indexPath) as! SettingTableViewCell
        
        return cell
    }
    
}

