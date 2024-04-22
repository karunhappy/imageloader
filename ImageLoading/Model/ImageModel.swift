//
//  ImageModel.swift
//  ImageLoading
//
//  Created by Karun Aggarwal on 22/04/24.
//

import Foundation

struct ImageModel: Codable, Hashable {
    var id: String
    var title: String
    var language: String
    var mediaType: Int
    var coverageURL: String
    var thumbnail: Thumbnail
}

struct Thumbnail: Codable, Hashable {
    var id: String
    var version: Int
    var domain: String
    var basePath: String
    var key: String
    
    var image: String {
        domain + "/" + basePath + "/10/" + key
    }
    var fullImage: String {
        domain + "/" + basePath + "/40/" + key
    }
}
