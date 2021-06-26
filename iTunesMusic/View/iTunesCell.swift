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
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    static let width = floor(UIScreen.main.bounds.width - 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = Self.width
//        print(widthConstraint.constant)
//        print(descriptionLabel.frame.width)
    }
    
    func update(withSong song:Song){
        nameLabel.text = song.trackName
        songImage.image = UIImage(systemName: "photo")
        songImage.contentMode = .scaleAspectFit
        guard let url = song.artworkUrl100 else { return }
        iTunesController.shared.fetchImageWithURL(url) { (image) in
            DispatchQueue.main.async {
                self.songImage.image = image
                self.songImage.contentMode = .scaleAspectFit
            }
        }
    }

}
