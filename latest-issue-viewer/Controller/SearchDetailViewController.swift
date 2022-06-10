//
//  SearchDetailViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//

import UIKit
import RealmSwift

class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salesDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    
    var bookTitleValue :String?
    var isbnValue :String?
    var authorNameValue :String?
    var bookImageValue :String?
    var priceValue :Int?
    var publisherValue :String?
    var salesDateValue:String?
    
    var allItems:Results<Favorite>?
    var filterItems:Results<Favorite>?
    
    let realm = try! Realm()
    var favoriteList:List<Favorite>!
    
    @IBOutlet weak var addStyleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // favoriteListの一番目にアイテムが入ってたら返す
        favoriteList = realm.objects(FavoriteList.self).first?.favList
        //　ボタンのスタイルを変更
        judgeButtonStyle()
        // 本のタイトル
        bookTitleLabel.text = bookTitleValue
        // 著者名
        authorNameLabel.text = authorNameValue
        // 価格
        if let price = priceValue{
            priceLabel.text = "\(String(price))円"
        }
        // 出版社
        publisherLabel.text = publisherValue
        // 発売日
        salesDateLabel.text = salesDateValue
        // 本の画像を表示する
        imageSetting()
        
    }
    
    // 本の画像を表示する
    func imageSetting(){
        if let urlString = bookImageValue {
            let url = URL(string: urlString)
            
            do{
                let imageData = try Data(contentsOf: url!)
                bookImageImageView.image = UIImage(data: imageData)
            } catch {
                print("画像が取得できませんでした。")
            }
        } else {
            //nilの場合は固定画像表示
            bookImageImageView.image = UIImage(named: "dog2")
        }
    }
    
    // 本をお気に入りに登録する
    @IBAction func addFavoriteBook(_ sender: Any) {
        
        // isbnのデータがあるかどうか
        if judgeDB() {
            print("既にDBに登録してあります")
            do {
                let realm = try! Realm()
                // isbnでフィルターをかけたデータ
                filterItems = try! Realm().objects(Favorite.self).filter("isbn == %@", isbnValue)
                try realm.write({
                    //削除するデータ
                    realm.delete(filterItems!)
                })
                judgeButtonStyle()
            }catch{
                print("RealmDB delete error")
            }
            
        }else{
            // データがなければ
            var favorite = Favorite()
            
            do {
                // 全データの取得
                allItems = realm.objects(Favorite.self)
                // ID
                var insertID:Int = 1
                //データが未登録ならIDに1を設定
                if (allItems != nil && allItems!.count != 0){
                    // IDの最大値を取得して+1した値を設定
                    let num = allItems!.value(forKeyPath: "@max.id") as! Int
                    insertID = num + 1
                }
                //登録するデータの作成
                favorite = Favorite(value: ["id" : insertID ,"isbn": isbnValue, "title" : bookTitleValue,"salesDate":salesDateValue,"mediumImageUrl": bookImageValue])
                
                try realm.write({ () -> Void in
                    if self.favoriteList == nil {
                        let favoriteItemList = FavoriteList()
                        favoriteItemList.favList.append(favorite)
                        self.realm.add(favoriteItemList)
                        self.favoriteList = self.realm.objects(FavoriteList.self).first?.favList
                    }else{
                        favoriteList.append(favorite)
                    }
                    //realm.add(favorite, update: .modified)
                })
                
                // 新刊発売日を設定すべきリストを取得
                Notification().getNotificationData()
                // UserDefaultsの参照
                let notifiDate = UserDefaults.standard.object(forKey: "notifiDate") as? Int ?? 1
                // ローカルプッシュ通知を設定する
                Notification().notificationAction(notifiDate)
                // ボタンのスタイルを変更する
                judgeButtonStyle()
                
                // realmファイルのパスを表示
                print(Realm.Configuration.defaultConfiguration.fileURL!)
                
            }catch{
                print("RealmDB add error")
            }
        }
    }
    
    // ボタンのスタイルを変更する関数
    func judgeButtonStyle(){
        
        // isbnのデータがあるかどうか
        if judgeDB() {
            // isbnとマッチしたデータの要素数が１以上なら
            // isbnがマッチしたデータがあればボタンを赤くする
            addStyleButton.backgroundColor = UIColor.red
            // isbnがマッチしたデータがあればボタンテキストを変更する
            addStyleButton.setTitle("登録済み", for: .normal)
        }else{
            // isbnとマッチしたデータの要素数が0なら
            // isbnがマッチしたデータがあればボタンを赤くする
            addStyleButton.backgroundColor = UIColor.blue
            // isbnがマッチしたデータがあればボタンテキストを変更する
            addStyleButton.setTitle("この本をお気に入りに登録する", for: .normal)
        }
    }
    
    // isbnがDBに存在するか判定する関数
    func judgeDB() -> Bool {
        
        var judgeDataExist:Bool = false
        // isbnでフィルターをかけたデータ
        filterItems = try! Realm().objects(Favorite.self).filter("isbn == %@", isbnValue)
        
        if let filterData = filterItems {
            if filterData.count > 0 {
                // データが存在するとき
                judgeDataExist = true
            }
        }        
        return judgeDataExist
    }
}
