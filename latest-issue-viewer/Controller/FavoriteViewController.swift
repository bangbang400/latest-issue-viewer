//
//  FavoriteViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/04.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var favorite_table_view: UITableView!
    
    let favorite_dammydata = ["Apple","Banana","Grape","Pinapple"]
    let releaseDate_dammydata = ["2022/03/01","2022/04/01","2022/05/01","2022/06/01"]
    
    var favoriteList:Results<Favorite>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // テーブルの登録
        favorite_table_view.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteTableView")
        
        // Realmにダミーデータを追加
        addDammyData()
        
        // Realmインスタンスの取得
        let realm = try! Realm()
        // DB全件取得
        self.favoriteList = realm.objects(Favorite.self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return favorite_dammydata.count
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTableView", for: indexPath) as! FavoriteTableViewCell
        // 本のタイトル
//        cell.favoriteTitle_label.text = favorite_dammydata[indexPath.row]
        cell.favoriteTitle_label.text = favoriteList[indexPath.row].title
        // 本の発売日
//        cell.releaseDate_label.text = releaseDate_dammydata[indexPath.row]
        cell.releaseDate_label.text = favoriteList[indexPath.row].salesDate
        
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // ダミーデータを追加
    func addDammyData(){
        let favoriteItem = Favorite()
        favoriteItem.title = "テストデータ"
        favoriteItem.salesDate = "2022/05/19"
        
        // インスタンスをRealmに保存
        do {
            let realm = try! Realm()
            try realm.write({ () -> Void in
                realm.add(favoriteItem)
            })
        }catch{
            
        }
    }
        
}
