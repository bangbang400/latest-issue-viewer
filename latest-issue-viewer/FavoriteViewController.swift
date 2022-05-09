//
//  FavoriteViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/04.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var favorite_table_view: UITableView!
    
    let favorite_dammydata = ["Apple","Banana","Grape","Pinapple"]
    let releaseDate_dammydata = ["2022/03/01","2022/04/01","2022/05/01","2022/06/01"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        // テーブルの登録
        favorite_table_view.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteTableView")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite_dammydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTableView", for: indexPath) as! FavoriteTableViewCell
        // 本のタイトル
        cell.favoriteTitle_label.text = favorite_dammydata[indexPath.row]
        // 本の概要
        cell.releaseDate_label.text = releaseDate_dammydata[indexPath.row]
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
}
