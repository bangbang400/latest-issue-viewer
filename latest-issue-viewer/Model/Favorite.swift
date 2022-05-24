//
//  Favorite.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/19.
//

import Foundation
import RealmSwift

class Favorite:Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var isbn:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var salesDate:String = ""
    @objc dynamic var mediumImageUrl:String?
    
    // Primary Keyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
