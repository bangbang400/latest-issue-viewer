//
//  CalendarViewController.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/13.
//

// pulrequ Test

import UIKit
import FSCalendar

protocol BookApiDelegate:AnyObject{
    func getAPI(_ title:String , _ booksGenreId:String)
}
class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource{

    @IBOutlet weak var decisionButton: UIButton!
    @IBOutlet weak var fsCal: FSCalendar!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var periodDateLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    // delegate
    weak var delegate:BookApiDelegate?
    // 開始日
    var startDate:Date?
    // 終了日
    var periodDate:Date?
    // 期間
    var days:[Date]?
    // フォーマットを設定
    let format = "yyyy/MM/dd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateLabel.backgroundColor = UIColor(hex: "ffffff")
        periodDateLabel.backgroundColor = UIColor(hex: "ffffff")
        tokenLabel.backgroundColor = UIColor(hex: "ffffff")
        // 月ごと
//        calendarView.setScope(.month, animated: true)
        // 週ごと
//        calendarView.setScope(.week, animated: true)
        fsCal.allowsMultipleSelection = true
        // 開始日か終了日か判定するメッセージ
        tokenLabel.text = "開始日と終了日を選択してください"
        // 設定ボタンを無効にしておく
        decisionButton.isEnabled = false
        decisionButton.backgroundColor = UIColor.lightGray
        // カレンダーをタップしたときの動作を可能にする
        fsCal.delegate = self
        fsCal.dataSource = self
    }
    // 同じ日付を２回タップしたときの処理
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // print("既に選択している日付をタップしています")
        // print("Top_days!.count:\(days?.count)")
        // 終了日を選択しようとしている時
        if days!.count == 1 {
            // 処理の内容をTokenLabelに表示する
            tokenLabel.text = "決定ボタンを選択してください。"
            // 日付を選択する
            fsCal.select(date)
            // 開始日と終了日が同じとき
//            print("正常2:開始日と終了日が同じです")
            print("２回タップしたとき：days!.count == 1")
            print("IFELSE_days!.count:\(days!.count)")
            // 選択解除しないようにする
            fsCal.select(date)
            // 終了日ラベルに表示する
            periodDateLabel.text = stringFormat(date: date, format: format)
            // 終了日に選択した日付を設定する
            periodDate = date
            // 開始日と終了日の期間をリセットする
            days = []
            // 設定ボタンを有効にしておく
            decisionButton.isEnabled = true
            decisionButton.backgroundColor = UIColor.yellow
        }else{
            // 開始日を選択しようとしている時
//            print("正常2:開始日と終了日が同じです")
            print("２回タップしたとき：days!.count == 1 else")
            print("IFELSE_days!.count:\(days!.count)")
            // 開始日を選択している時
            // 処理の内容をTokenLabelに表示する
            tokenLabel.text = "終了日を選択してください。"
            // 期間をリセットする
            for d in days!{
                fsCal.deselect(d)
            }
            // 終了日をリセットする
            periodDate = nil
            // 終了日のラベルをリセットする
            periodDateLabel.text = ""
            // 日付を選択する
            fsCal.select(date)
            // 開始日ラベルに表示する
            startDateLabel.text = stringFormat(date: date, format: format)
            // 開始日に選択した日付を設定する
            startDate = date
            // 配列に設定する
            days = datesRange(from: startDate!, to: date)
            // 設定ボタンを無効にしておく
            decisionButton.isEnabled = false
            decisionButton.backgroundColor = UIColor.lightGray
        }
    }
    // カレンダーの日付がタップされた時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // print("タップされました")
        if startDate == nil {
            // 開始日が決まっていない場合
            // 処理の内容をTokenLabelに表示する
            tokenLabel.text = "終了日を選択してください。"
            // 開始日に選択した日付を設定する
            startDate = date
            // ラベルに表示する
            startDateLabel.text = stringFormat(date:date,format:format)
            // 配列に設定する
            days = datesRange(from: startDate!, to: date)
            print("1回タップしたとき：開始日がnil")
            print("IFELSE_days!.count:\(days!.count)")
            // 設定ボタンを無効にしておく
            decisionButton.isEnabled = false
            decisionButton.backgroundColor = UIColor.lightGray
        }else if periodDate == nil{
            // 終了日が決まっていない場合
            if startDate?.compare(date) == .orderedAscending {
                // 処理の内容をTokenLabelに表示する
                tokenLabel.text = "決定ボタンを選択してください。"
//                print("正常1:開始日が終了日より前の時")
                // 開始日が終了日より前の時
                // ラベルに表示する
                periodDateLabel.text = stringFormat(date: date, format: format)
                // 配列に設定する
                days = datesRange(from: startDate!, to: date)
                print("1回タップしたとき：終了日がnil")
                print("IFELSE_days!.count:\(days!.count)")
                // 範囲をドットで埋める
                for d in days!{
                    fsCal.select(d)
                }
                // 終了日に選択した日付を設定する
                periodDate = date
                // 設定ボタンを有効にしておく
                decisionButton.isEnabled = true
                decisionButton.backgroundColor = UIColor.yellow
            }else{
                print("エラー：終了日が開始日よりも前です")
                print("IFELSE_days!.count:\(days!.count)")
                // 処理の内容をTokenLabelに表示する
                tokenLabel.text = "終了日が開始日よりも前です。もう一度、開始日を選択してください。"
                // エラー処理：終了日が開始日よりも前を選択した場合
                // 選択した日付をリセットする
                fsCal.deselect(date)
                // 開始日をリセットする
                fsCal.deselect(startDate!)
                // 開始日と終了日のラベルをリセットする
                startDateLabel.text = ""
                periodDateLabel.text = ""
                startDate = nil
                // 設定ボタンを無効にしておく
                decisionButton.isEnabled = false
                decisionButton.backgroundColor = UIColor.lightGray
            }
        // 開始日と終了日が決まっていた場合
        }else {
            print("開始日と終了日が決まっていた場合")
            print("IFELSE_days!.count:\(days!.count)")
            // 処理の内容をTokenLabelに表示する
            tokenLabel.text = "終了日を選択してください"
            // 開始日と終了日を解除する
            fsCal.deselect(startDate!)
            fsCal.deselect(periodDate!)
            // 今選択した日付を開始日に設定する
            startDate = date
            // 今選択した日付を開始日のラベルに表示する
            startDateLabel.text = stringFormat(date:date,format:format)
            // 終了日をリセットする
            periodDate = nil
            // 終了日のラベルをリセットする
            periodDateLabel.text = ""
            // 期間をリセットする
            for d in days!{
                fsCal.deselect(d)
            }
            // 開始日と終了日の期間をリセットする
            days = []
            // 配列に設定する
            days = datesRange(from: startDate!, to: date)
            // 設定ボタンを無効にしておく
            decisionButton.isEnabled = false
            decisionButton.backgroundColor = UIColor.lightGray
        }
    }
    // 設定ボタンを押した時
    @IBAction func decisionButtonAction(_ sender: Any) {
        dismiss(animated: true)
        // 処理を任せるSearchViewController
//        let searchVC = SearchViewController()
        if startDate != nil || periodDate != nil {
            // タブコントローラー
            let preTC = self.presentingViewController as! UITabBarController
            // ナビゲーションコントローラー
            let preNC = preTC.selectedViewController as! UINavigationController
            // ビューコントローラー
            let preVC = preNC.topViewController as! SearchViewController
            // 開始日と終了日を設定する
            preVC.startDate = stringFormat(date: startDate!, format: format)
            preVC.periodDate = stringFormat(date: periodDate!, format: format)            
            // 検索フォームに表示する
            let startDateText = stringFormat(date: startDate!, format:format)
            let periodDateText = stringFormat(date: periodDate!, format:format)
            preVC.search_form.placeholder = "\(startDateText)〜\(periodDateText)"
            // 日付フィルターを設定してAPI検索を実行する
            preVC.getAPI("", "", startDateText, periodDateText)
            // 検索画面に戻る
            dismiss(animated: true, completion: nil)
        }
//        let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
//        self.delegate = searchVC
//
//        if let dg = self.delegate {
////            dg.getAPI("進撃の巨人", "001001")
//            dg.getAPI("", "")
//        } else {
//            print("何もしない")
//        }
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
    // datesRangeメソッド (コピー)
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }    
}
