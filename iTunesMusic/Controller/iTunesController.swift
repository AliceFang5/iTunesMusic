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

//    let baseURL = URL(string: "https://itunes.apple.com/")!
//    if let urlStr = "https://itunes.apple.com/search?term=周杰倫&media=music".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr){
    
    func fetchiTunesMusic(withSearch search:String, completion: @escaping ([Song]?) -> Void){
//        let url = baseURL.appendingPathComponent("search?term=\(search)")
//        print(url)
        
        let urlStr = "https://itunes.apple.com/search?term=\(search)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlStr) else { return }
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
        print(#function)
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}
