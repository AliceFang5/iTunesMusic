//
//  Model.swift
//  iTunesMusic
//
//  Created by 方芸萱 on 2021/6/25.
//

import Foundation

struct SongResults : Decodable {
    let resultCount: Int
    let results: [Song]
}

struct Song : Decodable {
    let trackName: String?
    let collectionName: String?
    let previewUrl: URL?
    let artworkUrl100: URL?
    let longDescription: String?
}
