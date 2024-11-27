//
//  TrendingModel.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import Foundation


struct TrendingModel: Codable {
    let results: [Results]
}

struct Results: Codable {
    let title, poster, subTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case poster = "poster_path"
        case subTitle = "overview"
    }
}
