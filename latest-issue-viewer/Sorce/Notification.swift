//
//  Notification.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/09.
//

import Foundation
import RealmSwift
import UserNotifications

class Notification {
    // Realmインスタンスを取得
    let realm = try! Realm()
    // 通知するデータを保存する
    var notificationDataObj:Results<Favorite>!
    var notificationDataList:List<Favorite>!
                
    // 新刊発売日を設定すべきリストを取得
    func getNotificationData(){
        //        notificationDataList
        //        print(notificationDataObj)
        var modDate:String
        var setDay:Date
        //今日の日付
        var nowDate = Date()
        // dateFormatterの生成
        let dataFormatter = DateFormatter()
        
        // DB全件取得
        notificationDataObj = realm.objects(Favorite.self)
        //　通知用リスト
        notificationDataList = realm.objects(FavoriteList.self).first?.notifiList
        
        // DBからsalesDate(発売日)をフィルタして取得する
        for data in notificationDataObj{
            //            print(data)
            // print(data.salesDate)
            // print(data.salesDate.filter("0123456789".contains(_:)))
            // 数値だけ取り出し
            modDate = data.salesDate.filter("0123456789".contains(_:)) ?? "111111"
            // 日付フォーマットの作成
            dataFormatter.dateFormat = "yyyyMMdd"
            // 設定した日付
            setDay = dataFormatter.date(from: modDate) ?? nowDate
            //            print(setDay)
            if setDay.compare(nowDate) == .orderedDescending || setDay.compare(nowDate) == .orderedSame {
                print("設定した日付は今日以降の場合、通知対象のリストに格納する")
                //                print(setDay)
                // 通知日が今日より後の時、リストに格納する
                //                print("getNotificationData:\(data)")
                do {
                    try realm.write({ () -> Void in
                        if self.notificationDataList == nil {
                            let notifiItemList = FavoriteList()
                            notifiItemList.notifiList.append(data)
                            self.realm.add(notifiItemList)
                            self.notificationDataList = self.realm.objects(FavoriteList.self).first?.notifiList
                        }else{
//                            print("notificationDataListがnilじゃない")
                            // フィルターかけたデータ
//                            print(notificationDataList)
                            // 通知対象リストの中に
//                            let checkedData = self.realm.objects(FavoriteList.self).filter("isbn == %@", data.isbn)
                            let checkedData = self.realm.objects(FavoriteList.self).first?.notifiList.filter("isbn == %@", data.isbn)
                            print("checkedDataの中身→\(checkedData)")
                            if checkedData?.count == 0{
                                notificationDataList.append(data)
                            }
                        }
                    })
                }catch{
                    print("Realm add error")
                }
            }
        }
    }
    // データクレンジングする
    // 日付
    // ローカルプッシュ通知
    func notificationAction(_ setDaysAgo:Int){
        
        var modifiedDate:Date
        var modDate:String
        var setDay:Date
        var settingDays:Int
        //今日の日付
        var nowDate = Date()
        
        // dateFormatterの生成
        let dataFormatter = DateFormatter()
        
        //　通知用リスト
        notificationDataList = realm.objects(FavoriteList.self).first?.notifiList
        
        // 日付フォーマットの作成
        dataFormatter.dateFormat = "yyyyMMdd"
        settingDays = setDaysAgo

        // 何日前に通知するか計算する
        if setDaysAgo >= 1 {
            settingDays *= -1
        }
        // 取り出して、それぞれ設定する
        if self.notificationDataList != nil {
            print("notificationAction:\(notificationDataList)")
            for data in notificationDataList {
                print(data.title)
                print("通知します！！！")
                //                print(data.title)
                // 数値だけ取り出し
                modDate = data.salesDate.filter("0123456789".contains(_:)) ?? "111111"
                // 設定した日付
                setDay = dataFormatter.date(from: modDate) ?? nowDate
                
                if setDay.compare(nowDate) == .orderedSame || setDay.compare(nowDate) == .orderedSame {
                    // 発売日が今日以前の場合、今日の日付を入れる
                    setDay = nowDate
                }
                //計算後の日付
                modifiedDate = Calendar.current.date(byAdding: .day, value: settingDays, to: setDay)!
                
                //                print("day\(day)modifiedDate:\(modifiedDate)")
                let content = UNMutableNotificationContent()
                // 本の名称
                content.title = data.title
                content.body = "発売日は\(data.salesDate)"
                content.sound = UNNotificationSound.default
                // 直接日時を設定
//                let triggerDate = DateComponents(month:6, day:9, hour:20, minute:28, second: 00)
                let triggerDate = Calendar.current.dateComponents(in: TimeZone.current, from: modifiedDate)
                print(triggerDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: data.isbn, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
        
        if self.notificationDataList == nil {
            print("notificationDataListがnilである")
        }
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        // 音を変更する
        //        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "sound.mp3"))
    }

}
