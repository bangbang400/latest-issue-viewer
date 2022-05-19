//
//  SearchFilterViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/15.
//

import UIKit

class SearchFilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var genreTableView: UITableView!
    var genreArray = ["漫画（コミック)","語学・学習参考書","絵本・児童書・図鑑","小説・エッセイ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableViewCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = genreArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    // セルがタップされた時のアクション
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 検索画面に戻る
        dismiss(animated: true, completion: nil)
    }
    
    // 値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
        
}
