//
//  TrackResponseModel.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 13/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation

// MARK: - TrackResponseModel
struct TrackResponseModel: Codable {
    let album: TrackAlbum
    let artists: [TrackArtist]
    let availableMarkets: [String]
    let discNumber, durationMS: Int
    let explicit: Bool
    let externalIDS: ExternalIDS
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewURL: String
    let trackNumber: Int
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album
struct TrackAlbum: Codable {
    let albumType: String
    let artists: [TrackArtist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [Image]
    let name, releaseDate, releaseDatePrecision: String
    let totalTracks: Int
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - TrackArtist
struct TrackArtist: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id, name, type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}
