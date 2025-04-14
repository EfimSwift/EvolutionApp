//
//  SpotifyAPI.swift
//  EvolutionApp
//
//  Created by user on 14.04.2025.
//

import Alamofire

class SpotifyAPI {
    static let shared = SpotifyAPI()
    private let clientID = "YOUR_CLIENT_ID"
    private let clientSecret = "YOUR_CLIENT_SECRET"
    private var accessToken: String?
    
    private init() {}
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        let url = "https://accounts.spotify.com/api/token"
        let parameters = [
            "grant_type": "client_credentials",
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], let token = json["access_token"] as? String {
                        self.accessToken = token
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
            }
    }
    
    func fetchPlaylist(playlistID: String, completion: @escaping ([String: Any]?) -> Void) {
        guard let token = accessToken else {
            completion(nil)
            return
        }
        
        let url = "https://api.spotify.com/v1/playlists/\(playlistID)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(json)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
    }
}
