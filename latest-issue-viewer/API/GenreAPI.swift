//
//  Genre.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/12.
//

import Foundation

// ジャンル親リスト
struct GenreObjects:Codable{
    let children: [GenreObject]
}
// ジャンル子リスト
struct GenreObject:Codable {
    let child:Genre
}
// １件のジャンル
struct Genre:Codable{
    let booksGenreId:String
    let booksGenreName:String
}
