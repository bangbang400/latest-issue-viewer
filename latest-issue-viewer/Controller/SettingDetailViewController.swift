//
//  SettingDetailViewController.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/06.
//

import UIKit

class SettingDetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var countDatePicker: UIPickerView!
    @IBOutlet weak var countDateLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    let countDateList:[String] = ["当日に通知","1日前","2日前","3日前","4日前","5日前","6日前","7日前"]
    
    // 発売日通知日をUserDefaultsで保存する
    let countDateUD = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countDatePicker.dataSource = self
        countDatePicker.delegate = self
        // ラベル
        countDateLabel.text = "新刊発売の通知日を設定"
        // ボタンのデザイン
        settingButton.backgroundColor = UIColor.blue
        settingButton.setTitle("設定する", for: .normal)
        // pickerの初期値
        let notifiDate = countDateUD.object(forKey: "notifiDate") as? Int ?? 1
        countDatePicker.selectRow(notifiDate, inComponent: 0, animated: false)
    }
    
    // ドラムロールのタイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return countDateList[row]
        default:
            return "error"
        }
    }
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countDateList.count
    }
    // ドラムロールの選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countDateUD.set(row, forKey: "notifiDate")
    }
    // ドラムロールの行の高さ
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
