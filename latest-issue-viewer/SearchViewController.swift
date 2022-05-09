//
//  SearchViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/04.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var search_form: UISearchBar!
    @IBOutlet weak var api_tableView: UITableView!
    
    let dammy_data = ["Apple","Banana","Grape","Pinapple"]
    let dammy_overViewdata = ["アイウエオかきくけこ","アイウエオかきくけこ","アイウエオかきくけこ","アイウエオかきくけこ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カスタムセルの登録
        api_tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil),forCellReuseIdentifier:"bookTableView")
        
        // SearchBarで起きたイベントをこのクラスで受け取り、処理できるようになる
        search_form.delegate = self
        
        
        // APIを取得する
        // getAPI()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dammy_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookTableView", for: indexPath) as! BookTableViewCell
        // 本のタイトル
        cell.book_title_label.text = dammy_data[indexPath.row]
        // 本の概要
        cell.book_overview_textfield.text = dammy_overViewdata[indexPath.row]
        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //　セルがタップされた時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard =  self.storyboard!
        let detailSearchVC = storyboard.instantiateViewController(withIdentifier: "toSearchDetailViewController") as! SearchDetailViewController
        
        // 値を設定
        detailSearchVC.testValue = "test"
        self.present(detailSearchVC, animated: true, completion: nil)
        
    }
    
    // 検索フォームの処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        // 検索フォームに値が入っているかチェック
        if let search_title = search_form.text {
            print(search_title)
            getAPI(search_title)
        }
    }
    
    // APIを取得する関数
    func getAPI(_ title:String){
        // urlの固定値
        let urlFixed = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title="
        // アプリケーションID
        let appId = "applicationId=1009562445284140860"
        // URLの結合
        let urlString:String = "\(urlFixed)\(title)&\(appId)"
        // let urlString = "\(urlFixed)&\(appId)"
        print("文字列時のURL\(urlString)")
        
        // パーセントエンコーディング
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("パーセントエンコーディング時のURL\(encodeUrlString)")
        
        // URLを生成
        let url = URL(string: encodeUrlString)
        // requestを生成
        let request = URLRequest(url: url!)
        // 返却用
        var stringJsonData:String = ""
        
        // URLをもとにAPIを取得する(非同期で通信)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // データがないときはreturn
            guard let data = data else { return }
            // jsonへ変換
            do {
                // 一旦、String:Any型へ変換する
                let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                // 再度jsonをパースする
                let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                //print(jsonData)
                // utf8にしてデータを保存する
                stringJsonData = String(data: data, encoding: .utf8) ?? ""
                print(stringJsonData)
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}