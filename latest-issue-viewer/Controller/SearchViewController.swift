//
//  SearchViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/04.
//
//
//
import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BookApiDelegate {
    
    @IBOutlet weak var search_form: UISearchBar!
    @IBOutlet weak var api_tableView: UITableView!
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    // API検索をインスタンス変数に持つ
//    let getBookApi = GetBookAPI()
    // let dammy_data = ["Apple","Banana","Grape","Pinapple"]
    // let dammy_overViewdata = ["アイウエオかきくけこ","アイウエオかきくけこ","アイウエオかきくけこ","アイウエオかきくけこ"]
    // ブックデータ
    var bookData = [BookObject]()
    var genreId:String?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        // カレンダーボタンの調整
//        genreButton.imageView?.contentMode = .scaleAspectFill
//        genreButton.contentHorizontalAlignment = .fill
//        genreButton.contentVerticalAlignment = .fill
        // カスタムセルの登録
        api_tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil),forCellReuseIdentifier:"bookTableView")
        // SearchBarで起きたイベントをこのクラスで受け取り、処理できるようになる
        search_form.delegate = self
        // タップイベントを管理する
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false                                
    }
    override func viewWillAppear(_ animated: Bool) {
        self.api_tableView.reloadData()
    }
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookData.count
        //        return BookObjects.
    }
    // セルに表示させる内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookTableView", for: indexPath) as! BookTableViewCell
        let bookDataItem = bookData[indexPath.row]
        // 本のタイトル
        cell.book_title_label.text = bookDataItem.Item.title
        // 本の画像
        if let urlString = bookDataItem.Item.mediumImageUrl {
            let url = URL(string: urlString)
            
            do{
                let imageData = try Data(contentsOf: url!)
                cell.book_image_imageView.image = UIImage(data: imageData)
            } catch {
                print("画像が取得できませんでした。")
            }
        } else {
            cell.book_image_imageView.image = UIImage(named: "dog2") //nilの場合は固定画像表示
        }
        // 本の販売日
        cell.book_salesDate_textfield.text = bookDataItem.Item.salesDate
        return cell
    }
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //　セルがタップされた時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時にセルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移する
        performSegue(withIdentifier: "toSearchDetailController", sender: indexPath.row)
    }
    // 詳細ページへ値を受け渡すための準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchDetailController" {
            if let detailVC = segue.destination as? SearchDetailViewController,let index = sender as? Int {
                
                let bookDataItem = bookData[index]
                // 本のタイトル
                detailVC.bookTitleValue = bookDataItem.Item.title
                // isbn
                detailVC.isbnValue = bookDataItem.Item.isbn
                // 著者
                detailVC.authorNameValue = bookDataItem.Item.author
                // 本の画像
                detailVC.bookImageValue = bookDataItem.Item.mediumImageUrl
                // 価格
                detailVC.priceValue = bookDataItem.Item.itemPrice
                // 出版社
                detailVC.publisherValue = bookDataItem.Item.publisherName
                // 発売日
                detailVC.salesDateValue = bookDataItem.Item.salesDate
                
            }
        }
    }
    // キーボードを閉じる
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        view.endEditing(true)
////        search_form.resignFirstResponder()
//        view.endEditing(true)
//        print("タッチされたよ")
//    }
//    @IBAction func unwind(_ segue: UIStoryboardSegue) {
//        let from = segue.source as! SearchFilterViewController
//        self.genreId = from.genreId ?? "aaa"
//        print(self.genreId)
//        print(segue.identifier!)
//        search_form.placeholder = self.genreId
//    }
    // フィルター解除ボタン
    @IBAction func clearButtonAction(_ sender: Any) {
        // 設定されているフィルターを解除する
        genreId = ""
        search_form.placeholder = "本のタイトルを入力"
    }
    // キーボードを閉じる
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    // 検索フォームの処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        // 検索フォームに値が入っているかチェック
        if let search_title = search_form.text {
            // ジャンル選択中かどうかチェック
            if let genreId = genreId {
                getAPI(search_title, genreId)
            }else{
                // タイトルのみを設定
                getAPI(search_title, "")
            }
        }else{
            // ジャンル選択中かどうかチェック
            if let genreId = genreId {
                getAPI("", genreId)
            }else{
                // 空白を設定
                getAPI("", "")
            }
        }
    }
    // APIを取得する関数
    func getAPI(_ title:String , _ booksGenreId:String){
        print(title)
        // urlの固定値
        let urlFixed = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json"
        
        var fixedTitle:String
        var fixedGenreId:String
        
        // 日付変更フォーマッターを生成
        let dateFormatter:DateFormatter = DateFormatter()
        // フォーマッターにカレンダー表記を設定
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        // フォーマッターに引数から取得した任意のフォーマットを設定
        dateFormatter.dateFormat = "yyyyMMdd"
        // 日付
        var filterDate:String = "2022/06/23"
        
        // タイトルとジャンルの引数チェック
        if title != "" {
            // タイトルが設定されている
            if booksGenreId != ""{
                // ジャンルが設定されている
                fixedTitle = urlFixed + "&title=\(title)" + "&booksGenreId=\(booksGenreId)"
            }else{
                // タイトルだけ設定されている
                fixedTitle = urlFixed + "&title=\(title)"
            }
        }else {
            // タイトルが設定されていない
            if booksGenreId != ""{
                // ジャンルが設定されている
                fixedTitle = urlFixed + "&booksGenreId=\(booksGenreId)"
            }else{
                // タイトルもジャンルもなしの場合
                fixedTitle = urlFixed
            }
        }
        
        
        // アプリケーションID
        let applicationId = "1009562445284140860"
        // URLの結合
        let urlString:String = "\(fixedTitle)&applicationId=\(applicationId)"
         print("文字列時のURL\(urlString)")
        // パーセントエンコーディング
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // URLを生成
        let url = URL(string: encodeUrlString)
        // requestを生成
        let request = URLRequest(url: url!)
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
                // print(jsonData)
                // utf8にしてデータを保存する
                let stringJsonData = String(data: data, encoding: .utf8) ?? ""
                // print(stringJsonData)
                let dataCast: Data? = stringJsonData.data(using: .utf8)
                let json = try JSONDecoder().decode(BookObjects.self, from: dataCast!)
                // print(json)
                self.bookData = json.Items
                // テーブルのリロードはメインスレッドで行うようにする
                DispatchQueue.main.async() { () -> Void in
                    self.api_tableView.reloadData()
                }
            } catch let error {
                print("ブック検索APIからの取得に失敗\(error)")
            }
        }
        task.resume()
    }
    
}
