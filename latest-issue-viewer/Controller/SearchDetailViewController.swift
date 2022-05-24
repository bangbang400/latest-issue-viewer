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
    
    let favoriteItem = Favorite()
    var allItems:Results<Favorite>?
    var filterItems:Results<Favorite>?
    
    @IBOutlet weak var addStyleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // isbnでフィルターをかけたデータ
        filterItems = try! Realm().objects(Favorite.self).filter("isbn == %@", isbnValue)
        print(filterItems)
        
        // マッチしたデータがあれば、登録する
        if let filterData = filterItems {
            // データがあれば
            if filterData.count > 0 {
                print("既にDBに登録してあります")
            }else{
                // データがなければ
                // インスタンスをRealmに保存
                do {
                    let realm = try! Realm()
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
                    let favorite:Favorite = Favorite(value: ["id" : insertID ,"isbn": isbnValue, "title" : bookTitleValue,"salesDate":salesDateValue,"mediumImageUrl": bookImageValue])
                    try realm.write({ () -> Void in
                        realm.add(favorite, update: .modified)
                    })
                                        
                    // realmファイルのパスを表示
                    print(Realm.Configuration.defaultConfiguration.fileURL!)                                        
                    
                }catch{
                    print("RealmDB add error")
                }
            }
            
        }else{
            print("error")
        }
        
    }
    
    // ボタンのスタイルを変更する関数
    func judgeButtonStyle(){
        // isbnでフィルターをかけたデータ
        filterItems = try! Realm().objects(Favorite.self).filter("isbn == %@", isbnValue)
//        print(filterItems)
        
        if let filterData = filterItems {
            if filterData.count > 0 {
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
        }else{
            print("error")
        }
    }
}

//            var insertID:Int = 1
//
//            for _ in 0..<5{
//                //データがまだ登録されていなかったらIDに1を設定する
//                if(allUser != nil && allUser!.count != 0){
//                    //IDの最大値を取得して+1した値をIDにする
//                    let num = allUser!.value(forKeyPath: "@max.ID") as! Int
//                    insertID = num + 1
//                }
//
//                //登録するデータの作成
//                let user:UserTable = UserTable(value: ["ID" : insertID ,
//                                                       "userName" : "user"])
//                //データの追加
//                try! realm.write{
//                    realm.add(user, update: .modified)
//                }
//            }
//            allUser = realm.objects(UserTable.self)
