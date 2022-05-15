//
//  SearchDetailViewController.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/06.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salesDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    
    var bookTitleValue :String?
    var authorNameValue :String?
    var bookImageValue :String?
    var priceValue :Int?
    var publisherValue :String?
    var salesDateValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // 本の画像
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
}
