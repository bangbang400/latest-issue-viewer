//
//  SearchViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/04.
//
//
//
import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var search_form: UISearchBar!
    @IBOutlet weak var api_tableView: UITableView!
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var notApiDataText: UILabel!
    // API検索をインスタンス変数に持つ
    //    let getBookApi = GetBookAPI()
    // let dammy_data = ["Apple","Banana","Grape","Pinapple"]
    // let dammy_overViewdata = ["アイウエオかきくけこ","アイウエオかきくけこ","アイウエオかきくけこ","アイウエオかきくけこ"]
    // ブックデータ
    var bookData = [BookObject]()
    var genreId:String?
    
    var startDate:String?
    var periodDate:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ボタンの装飾
        genreButton.backgroundColor = UIColor(hex: "00bfff") //背景色 00bfff[deepskyblue]
        genreButton.tintColor = .white //文字色
        genreButton.layer.cornerRadius = 10 //角
        clearButton.backgroundColor = UIColor(hex: "d3d3d3") //背景色
        clearButton.tintColor = .black //文字色
        clearButton.layer.cornerRadius = 10 //角
//        genreButton.layer.shadowOpacity = 0.7 //影
//        genreButton.layer.shadowRadius = 3 // 不透明度
//        genreButton.layer.shadowColor = UIColor.black.cgColor //影の色
//        genreButton.layer.shadowOffset = CGSize(width: 5, height: 5) //影の方向 右,下
        
        // API検索結果を表示するテーブルの設定
        api_tableView.delegate = self
        api_tableView.dataSource = self
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
        startDate = nil
        periodDate = nil
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
        // 検索フォーム空白チェック
        if let search_title = search_form.text {
            // ジャンルチェック
            if let genreId = genreId {
                // 開始日チェック
                if let startDate = startDate {
                    // 終了日チェック
                    if let periodDate = periodDate {
                        getAPI(search_title, genreId,startDate,periodDate)
                    }else{
                        getAPI(search_title, genreId,startDate,"")
                    }
                }else{
                    getAPI(search_title, genreId,"","")
                }
            }else{
                getAPI(search_title,"","","")
            }
        }else{
            // ジャンルチェック
            if let genreId = genreId {
                // 開始日チェック
                if let startDate = startDate {
                    // 終了日チェック
                    if let periodDate = periodDate {
                        getAPI("",genreId,startDate,periodDate)
                    }else{
                        getAPI("",genreId,startDate,"")
                    }
                }else{
                    getAPI("",genreId,"","")
                }
            }else{
                // 開始日チェック
                if let startDate = startDate {
                    // 終了日チェック
                    if let periodDate = periodDate {
                        getAPI("","",startDate,periodDate)
                    }else{
                        getAPI("","",startDate,"")
                    }
                }else{
                    // 終了日チェック
                    if let periodDate = periodDate {
                        getAPI("","","",periodDate)
                    }else{
                        getAPI("","","","")
                    }
                }
            }
        }
    }    
    // APIを取得する関数
    func getAPI(_ title:String , _ booksGenreId:String, _ startDate:String,_ periodDate:String){
        print(title)
        // urlの固定値
        let urlFixed = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json"
        
        var fixedTitle:String
        var fixedGenreId:String
        
        self.bookData = []
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
                
                // 日付フィルターありの場合
                if startDate != "" || periodDate != "" {
                    
                    // 日付変更フォーマッターを生成
                    let dateFormatter:DateFormatter = DateFormatter()
                    // フォーマッターにカレンダー表記を設定
                    dateFormatter.calendar = Calendar(identifier: .gregorian)
                    // フォーマッターに引数から取得した任意のフォーマットを設定
                    dateFormatter.dateFormat = "yyyyMMdd"
                    // print("SVC:\(json.Items)")
                    //　開始日チェック
                    if startDate != "" {
                        // 開始日を数値だけにする
                        var filterStart = startDate.filter("0123456789".contains(_:))
                        // 指定した開始日(文字型→日付型)
                        var start = dateFormatter.date(from: filterStart)
                        
                        //終了日チェック
                        if periodDate != ""{
                            // 終了日を数値だけにする
                            var filterPeriod = periodDate.filter("0123456789".contains(_:))
                            // 指定した終了日(文字型→日付型)
                            var period = dateFormatter.date(from: filterPeriod)
                            //print("SVC2:\(self.bookData)")
                            // 開始日 <= データ <= 終了日
                            for item in json.Items{
                                // 発売日を変数に格納する
                                let filterSales = item.Item.salesDate
                                // 発売日を数値だけにする
                                var formatSalesDate = filterSales.filter("0123456789".contains(_:))
                                // 発売日を設定する(文字型→日付型)
                                var setDay = dateFormatter.date(from: formatSalesDate)
                                // 発売日が8桁より少ない場合
                                if formatSalesDate.count != 8 {
                                    
                                }else{
                                    print("処理中")
                                    // 数値だけ取り出した値が8桁以上なら→　例：「2022年06月30日」
                                    if setDay!.compare(start!) == .orderedSame ||
                                        setDay!.compare(start!) == .orderedDescending
                                    {
                                        if setDay!.compare(period!) == .orderedSame ||
                                            setDay!.compare(period!) == .orderedAscending {
                                            // 発売日が開始日以降の場合、表示する
                                            self.bookData.append(item)
                                        }
                                    }
                                }
                            }
                        }else{
                            // 開始日 <= データ
                            for item in json.Items{
                                // 発売日を変数に格納する
                                let filterSales = item.Item.salesDate
                                // 発売日を数値だけにする
                                var formatSalesDate = filterSales.filter("0123456789".contains(_:))
                                // 発売日を設定する(文字型→日付型)
                                var setDay = dateFormatter.date(from: formatSalesDate)
                                // 発売日が8桁より少ない場合
                                if formatSalesDate.count != 8 {
                                    
                                }else{
                                    // 数値だけ取り出した値が8桁以上なら→　例：「2022年06月30日」
                                    if setDay!.compare(start!) == .orderedSame ||
                                        setDay!.compare(start!) == .orderedDescending
                                    {
                                        // 発売日が開始日以降の場合、表示する
                                        self.bookData.append(item)
                                    }
                                }
                            }
                        }
                    }else{
                        // 終了日 <= データ
                        if periodDate != ""{
                            // 終了日を数値だけにする
                            var filterPeriod = periodDate.filter("0123456789".contains(_:))
                            // 指定した終了日(文字型→日付型)
                            var period = dateFormatter.date(from: filterPeriod)
                            
                            for item in json.Items{
                                // 発売日を変数に格納する
                                let filterSales = item.Item.salesDate
                                // 発売日を数値だけにする
                                var formatSalesDate = filterSales.filter("0123456789".contains(_:))
                                // 発売日を設定する(文字型→日付型)
                                var setDay = dateFormatter.date(from: formatSalesDate)
                                // 発売日が8桁より少ない場合
                                if formatSalesDate.count != 8 {
                                    
                                }else{
                                    // 数値だけ取り出した値が8桁以上なら→　例：「2022年06月30日」
                                    if setDay!.compare(period!) == .orderedSame ||
                                        setDay!.compare(period!) == .orderedAscending
                                    {
                                        // 発売日が開始日以降の場合、表示する
                                        self.bookData.append(item)
                                    }
                                }
                            }
                        }
                    }
                }else{
                    // 日付フィルターが未入力ならそのままAPI検索の通り格納する
                    self.bookData = json.Items
                }
                // テーブルのリロードはメインスレッドで行うようにする
                DispatchQueue.main.async() { () -> Void in
                    self.api_tableView.reloadData()
                    // API検索結果がnilだった場合
                    if self.bookData.count == 0 {
                        print("self.bookDataの中身\(self.bookData)")
                        self.notApiDataText.text = "該当データなし"
                    }else{
                        self.notApiDataText.text = ""
                    }
                }
            } catch let error {
                print("ブック検索APIからの取得に失敗\(error)")
            }
        }
        task.resume()
    }
    
}
