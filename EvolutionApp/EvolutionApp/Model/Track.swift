//
//  Track.swift
//  EvolutionApp
//
//  Created by user on 21.03.2025.
//

import Foundation

struct Track: Codable {
    let artist: String
    let title: String
}


struct Playlist: Codable {
    let name: String
    var tracks: [Track]
}
