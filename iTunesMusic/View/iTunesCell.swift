//
//  iTunesCell.swift
//  iTunesMusic
//
//  Created by 方芸萱 on 2021/6/25.
//

import UIKit

class iTunesCell: UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    static let width = floor(UIScreen.main.bounds.width - CGFloat(K.spacing * 2))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = Self.width
    }
    
    func update(withSong song:Song, collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath){
        nameLabel.text = song.trackName
        //if longDescription is nil, display artistName instead
        descriptionLabel.text = song.longDescription ?? song.artistName
        
        songImage.image = UIImage(systemName: "photo")
        songImage.contentMode = .scaleAspectFit
        guard let url = song.artworkUrl100 else { return }
        iTunesController.shared.fetchImageWithURL(url) { (result) in
            switch result{
            case .success(let image):
                    DispatchQueue.main.async {
                        //check indexPath before update image
                        if let currentIndexPath = collectionView.indexPath(for: cell), currentIndexPath != indexPath { return }
                        self.songImage.image = image
                        self.songImage.contentMode = .scaleAspectFill
                    }
            case .failure(let networkError):
                switch networkError {
                case .invalidUrl, .invalidData, .invalidResponse:
                    print(networkError)
                case .requestFailed(let error), .decodingError(let error):
                    print(networkError, error)
                }
            }
        }
    }
    
}
