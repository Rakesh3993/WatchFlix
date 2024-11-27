//
//  TVModel.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 25/11/24.
//

import Foundation


struct TVModel: Codable {
    let results: [Tvshows]
}

struct Tvshows: Codable {
    let title, poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_name"
        case poster = "poster_path"
    }
}
