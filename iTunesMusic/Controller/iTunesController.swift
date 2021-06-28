//
//  iTunesController.swift
//  iTunesMusic
//
//  Created by 方芸萱 on 2021/6/25.
//

import UIKit
import AVFoundation

class iTunesController{
    static let shared = iTunesController()
    let player = AVPlayer()
    let baseUrlString = "https://itunes.apple.com/"

    func fetchiTunesMusic(withSearch searchString:String, completion: @escaping ([Song]?) -> Void){
        var queries = [String:String]()
        queries["term"] = searchString
        //may add other queries in the future, like: media, country...etc
//        queries["term"] = "告五人"
//        queries["media"] = "music"
//        queries["country"] = "tw"
        
        let encodingString = baseUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let searchUrlString = encodingString?.appending("search")
        guard let searchUrl = URL(string: searchUrlString ?? "") else {
            print("URL generate fail")
            return
        }
        var component = URLComponents(url: searchUrl, resolvingAgainstBaseURL: true)!
        component.queryItems = queries.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = component.url else {
            print("URL add queryItems fail")
            return
        }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data{
                do {
                    let songResults = try jsonDecoder.decode(SongResults.self, from: data)
//                    print(songResults)
                    completion(songResults.results)
                } catch {
                    print(error)
                }
            }else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImageWithURL(_ url:URL, completion: @escaping (UIImage?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data{
                completion(UIImage(data: data))
            }else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func playPreviewURL(_ url:URL){
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}
