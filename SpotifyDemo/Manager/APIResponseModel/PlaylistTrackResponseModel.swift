//
//  PlaylistTrackResponseModel.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 13/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation

// MARK: - PlaylistTrackResponseModel
struct PlaylistTrackResponseModel: Codable {
    let href: String
    let items: [PlaylistsTrack]
    let limit: Int
   // let next: JSONNull?
    let offset: Int
   // let previous: JSONNull?
    let total: Int
}

// MARK: - PlaylistsTrack
struct PlaylistsTrack: Codable {
    let addedAt: String
    let addedBy: AddedBy
    let isLocal: Bool
 //   let primaryColor: JSONNull?
    let track: Track
    let videoThumbnail: VideoThumbnail
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
      //  case primaryColor = "primary_color"
        case track
        case videoThumbnail = "video_thumbnail"
    }
}

// MARK: - AddedBy
struct AddedBy: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let type: String
    let uri: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, type, uri, name
    }
}


// MARK: - Track
struct Track: Codable {
    let album: Album
    let artists: [AddedBy]
    let availableMarkets: [String]
    let discNumber, durationMS: Int
    let episode, explicit: Bool
    let externalIDS: ExternalIDS
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewURL: String?
    let track: Bool
    let trackNumber: Int
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case episode, explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case track
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album
struct Album: Codable {
    let albumType: String
    let artists: [AddedBy]
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


// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    let isrc: String
}

// MARK: - VideoThumbnail
struct VideoThumbnail: Codable {
    let url: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
