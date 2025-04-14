//
//  SpotifyManager.swift
//  EvolutionApp
//
//  Created by user on 14.04.2025.
//

import Foundation

class SpotifyManager {
    static let shared = SpotifyManager()
    
    private init() {}
    
    func setup() {
        SpotifyAPI.shared.authenticate { success in
            if success {
                print("Spotify authentication successful")
            } else {
                print("Spotify authentication failed")
            }
        }
    }
    
    func getPlaylist(playlistID: String, completion: @escaping ([String: Any]?) -> Void) {
        SpotifyAPI.shared.fetchPlaylist(playlistID: playlistID, completion: completion)
    }
}
