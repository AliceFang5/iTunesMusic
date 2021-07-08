//
//  iTunesController.swift
//  iTunesMusic
//
//  Created by 方芸萱 on 2021/6/25.
//

import UIKit
import AVFoundation

enum NetworkError: Error {
    case invalidUrl
    case requestFailed(Error)
    case invalidData
    case invalidResponse
    case decodingError(Error)
}

class iTunesController{
    static let shared = iTunesController()
    let player = AVPlayer()
    let baseUrlString = "https://itunes.apple.com/"

    func fetchiTunesMusic(withSearch searchString:String, completion: @escaping (Result<[Song], NetworkError>) -> Void){
        var queries = [String:String]()
        queries["term"] = searchString
        //may add other queries in the future, like: media, country...etc
//        queries["term"] = "告五人"
//        queries["media"] = "music"
//        queries["country"] = "tw"
        
        let encodingString = baseUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let searchUrlString = encodingString?.appending("search")
        guard let searchUrl = URL(string: searchUrlString ?? "") else {
            completion(.failure(.invalidUrl))
            return
        }
        var component = URLComponents(url: searchUrl, resolvingAgainstBaseURL: true)!
        component.queryItems = queries.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = component.url else {
            completion(.failure(.invalidUrl))
            return
        }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let error = error{
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
             
            do {
                let songResults = try jsonDecoder.decode(SongResults.self, from: data)
                completion(.success(songResults.results))
            } catch {
                completion(.failure(.decodingError(error)))
            }

        }
        task.resume()
    }
    
    func fetchImageWithURL(_ url:URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error{
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(image))
        }
        task.resume()
    }
    
    func playPreviewURL(_ url:URL){
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
//        player.
    }
    
    func stopPlayMusic(){
        player.pause()
    }
}
