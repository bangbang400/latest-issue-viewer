//
//  BookAPI.swift
//  latest-issue-viewer
//
//  Created by 馬場大和 on 2022/05/11.
//

import Foundation

// BookObjectsモデル
struct BookObjects:Codable{
    let pageCount:Int
    let page:Int
    let hits:Int
    let carrier:Int
    let Items: [BookObject]
}

struct BookObject:Codable{
    let Item:Book
}

struct Book: Codable{
    let title:String
    let isbn:String
    let author:String
    let mediumImageUrl:String?
    let salesDate:String
    let itemPrice:Int
    let publisherName:String
}
