//
//  Artwork.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import Foundation

struct Artwork: Codable, Identifiable, Equatable {
    let id = UUID().uuidString
    var objectId: Int?
    var department: String?
    var title: String?
    var primaryImage: String?
    var accessionYear: String?
    var artistDisplayName: String?
    var objectDate: String?
    var period: String?
    var artistWikidata_URL: String?
    var objectBeginDate: Int?
    var objectEndDate: Int?
    var linkResource: String?
    var objectURL: String?
    
    enum CodingKeys: CodingKey {
        case objectId, department, title, primaryImage, accessionYear, artistDisplayName, objectDate, period, artistWikidata_URL, objectBeginDate, objectEndDate, linkResource, objectURL
    }
}
