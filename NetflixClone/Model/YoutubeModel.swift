//
//  YoutubeModel.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 22/11/24.
//

import Foundation

struct YoutubeModel: Codable {
    let items: [Items]
}

struct Items: Codable {
    let id: VideoId
}

struct VideoId: Codable {
    let videoId: String?
}
