//
//  ViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/01.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var setting_tableView: UITableView!
    
    let countDateList:[String] = ["当日","1日前","2日前","3日前","4日前","5日前","6日前","7日前"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カスタムセルの登録
        setting_tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingTableView")
        // スクロールできないようにする
        setting_tableView.isScrollEnabled = false
        // リストを押下できないようにする
        // setting_tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        notificationAction()
        setting_tableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingTableView", for: indexPath) as! SettingTableViewCell
        
        // UserDefaultsの参照
        let notifiDate = UserDefaults.standard.object(forKey: "notifiDate") as? Int ?? 1
        cell.settingNotifiDateLabel.text = String(countDateList[notifiDate])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時にセルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移する
        performSegue(withIdentifier: "toSettingDetailController", sender: indexPath.row)
    }        
    
    // 値を渡す準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let setDetailVC = segue.destination as! SettingDetailViewController
        setDetailVC.countDateList = self.countDateList
    }
    
}

