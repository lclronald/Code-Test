//
//  AlbumsModel.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import Foundation
import ObjectMapper

class AlbumsModel: BaseModel {
    var resultCount: Int?
    var results: [AlbumsDetailModel] = []

    override func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}

class AlbumsDetailModel: BaseModel {
    @objc dynamic var artistName: String = ""
    @objc dynamic var wrapperType: String = ""
    @objc dynamic var collectionType: String = ""
    @objc dynamic var primaryGenreName: String = ""
    @objc dynamic var copyright: String = ""
    @objc dynamic var collectionId: Int = 0
    @objc dynamic var collectionName: String = ""
    @objc dynamic var collectionViewUrl: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var collectionCensoredName: String = ""
    @objc dynamic var collectionPrice: Double = 0.0
    @objc dynamic var artworkUrl60: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var artistId: Int = 0
    @objc dynamic var trackCount: Int = 0
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var amgArtistId: Int = 0
    @objc dynamic var artistViewUrl: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var collectionExplicitness: String = ""

    override static func primaryKey() -> String? {
        return "collectionId"
    }
    
    override func mapping(map: Map) {
        artistName <- map["artistName"]
        wrapperType <- map["wrapperType"]
        collectionType <- map["collectionType"]
        primaryGenreName <- map["primaryGenreName"]
        copyright <- map["copyright"]
        collectionId <- map["collectionId"]
        collectionName <- map["collectionName"]
        collectionViewUrl <- map["collectionViewUrl"]
        currency <- map["currency"]
        collectionCensoredName <- map["collectionCensoredName"]
        collectionPrice <- map["collectionPrice"]
        artworkUrl60 <- map["artworkUrl60"]
        artworkUrl100 <- map["artworkUrl100"]
        artistId <- map["artistId"]
        trackCount <- map["trackCount"]
        releaseDate <- map["releaseDate"]
        amgArtistId <- map["amgArtistId"]
        artistViewUrl <- map["artistViewUrl"]
        country <- map["country"]
        collectionExplicitness <- map["collectionExplicitness"]
    }
    
    func getPrice() -> String {
        return "\(currency) \(collectionPrice)"
    }
}
