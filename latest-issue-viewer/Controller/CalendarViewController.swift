//
//  CalendarViewController.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/13.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource{

    @IBOutlet weak var fsCal: FSCalendar!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var periodDateLabel: UILabel!
    
    var startDate:Date?
    var periodDate:Date?
    // フォーマットを設定
    let format = "yyyy/MM/dd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 月ごと
//        calendarView.setScope(.month, animated: true)
        // 週ごと
//        calendarView.setScope(.week, animated: true)
        fsCal.allowsMultipleSelection = true
    }
    // カレンダーの日付がタップされた時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if startDate == nil {
            // 開始日が決まっていない場合
            startDate = date
            // ラベルに表示する
            startDateLabel.text = stringFormat(date:date,format:format)
        }else if periodDate == nil{
            // 終了日が決まっていない場合
            periodDate = date
            // ラベルに表示する
            periodDateLabel.text = stringFormat(date: date, format: format)            
        }
    }
    // 日付を文字型へ変換する関数
    func stringFormat(date:Date, format:String) -> String{
        // 日付変更フォーマッターを生成
        let dateFormatter:DateFormatter = DateFormatter()
        // フォーマッターにカレンダー表記を設定
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        // フォーマッターに引数から取得した任意のフォーマットを設定
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}
