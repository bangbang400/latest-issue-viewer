//
//  SearchFilterViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/15.
//

import UIKit

class SearchFilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var genreTableView: UITableView!
//    var genreArray = ["漫画（コミック)","語学・学習参考書","絵本・児童書・図鑑","小説・エッセイ"]
    // ジャンル
    var genreItem:Genre?
    // ジャンルデータ
    var genreData = [GenreObject]()
    // ジャンルID
    var genreId:String?
    // ジャンル名
    var genreName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ジャンルAPIからジャンルリストを取得する
        getGenreAPI()
    }
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return genreArray.count
        return genreData.count
    }
    // セルに表示させる内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        // content.text = genreArray[indexPath.row]
        let genreDataItem = genreData[indexPath.row]
        // ジャンル名を設定
        content.text = genreDataItem.child.booksGenreName
        cell.contentConfiguration = content
        return cell
    }
    // セルがタップされた時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ジャンル
        genreItem = genreData[indexPath.row].child
        if let item = genreItem {
            // ジャンルIDを設定する
            genreId = item.booksGenreId
            // ジャンル名を設定する
            genreName = item.booksGenreName
        }
        // タブコントローラー
        let preTC = self.presentingViewController as! UITabBarController
        // ナビゲーションコントローラー
        let preNC = preTC.selectedViewController as! UINavigationController
        // ビューコントローラー
        let preVC = preNC.topViewController as! SearchViewController
        preVC.search_form.placeholder = genreName
        preVC.genreId = genreId
        // 検索画面に戻る
        dismiss(animated: true, completion: nil)
        // 0:root view Controller,n-1:view controller, n-2:１つ前のview controller
//        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! SearchViewController
//        let fromVC = self.storyboard?.instantiateViewController(withIdentifier: "")
//        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarControllerID") as! UITabBarController
//        tabVC.selectedIndex = 1
//        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarControllerID") as! UITabBarController
//        let naVC = tabVC.selectedViewController as! UINavigationController
//        let searchVC = naVC.viewControllers as! SearchViewController
//        searchVC.search_form.placeholder = genreId
//        let vc = self.presentingViewController as! SearchViewController
//        vc.search_form.placeholder = "テスト"
    }
    // ジャンルAPIからジャンルリストを取得
    func getGenreAPI(){
        // URLの固定値
        let urlFixed = "https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128?format=json"
        // ジャンルID
        let booksGenreId = "001"
        // アプリケーションID
        let applicationId = "1009562445284140860"
        // URLの結合
        let urlString:String = "\(urlFixed)&booksGenreId=\(booksGenreId)&applicationId=\(applicationId)"
        // パーセントエンコーディング
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // URLを生成
        let url = URL(string: encodeUrlString)
        // requestを生成
        let request = URLRequest(url: url!)
        // URLをもとにAPIを取得する
        let task = URLSession.shared.dataTask(with: request) { (data,response, error) in
            // データがないときはreturn
            guard let data = data else {return}
            // json形式へ変換
            do {
                // 一旦、String:Any型で受け取る
                let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                // この段階ではエラー
                // print("ジャンルID_jsonData\(jsonData)")
                // 再度jsonをパースする
                let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                // 取得したデータが何bytesか表示される
                // print("ジャンルID_data\(data)")
                // utf8にしてデータを保存する
                let stringJsonData = String(data:data, encoding: .utf8) ?? ""
                // print("ジャンルID_stringJsonData\(stringJsonData)")
                // Data型に再度キャストする
                let dataCast: Data? = stringJsonData.data(using: .utf8)
                // jsonにデコードする
                let json = try JSONDecoder().decode(GenreObjects.self, from: dataCast!)
                // print("ジャンルID_json\(json)")
                // jsonデータをGenreオブジェクトに格納する
                self.genreData = json.children
                // テーブルの描写はメインスレッドで行う
                DispatchQueue.main.async { () -> Void in
                    self.genreTableView.reloadData()
                }
            }catch let error {
                print("ジャンルAPIからの取得に失敗:\(error)")
            }
        }
        task.resume()
    }
        
}
