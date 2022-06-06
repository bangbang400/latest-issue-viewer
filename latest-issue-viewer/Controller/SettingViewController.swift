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
        // スクロールできないようにする
        setting_tableView.isScrollEnabled = false
        // リストを押下できないようにする
        // setting_tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationAction()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingTableView", for: indexPath) as! SettingTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時にセルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移する
        performSegue(withIdentifier: "toSettingDetailController", sender: indexPath.row)
    }
    
    func notificationAction(){
        let content = UNMutableNotificationContent()
        content.title = "新刊発売日まであと何日です"
        content.body = "急いで買いに行きましょう！！"
        
        // 画像を設定する
        // content.イメージ
        
        // 音を変更する
        //        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "sound.mp3"))
        // デフォルトサウンド
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}

