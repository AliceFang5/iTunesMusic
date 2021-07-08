//
//  iTunesCollectionViewController.swift
//  iTunesMusic
//
//  Created by 方芸萱 on 2021/6/25.
//

import UIKit

class iTunesCollectionViewController: UICollectionViewController {
    
    var songList = [Song]()
    var currentPlayingItemButton:UIButton?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "iTunes Music"
        insertSearchBar()
        initCollectionViewFlowLayout()
        collectionView.register(UINib(nibName: K.iTunesCellNibName, bundle: nil), forCellWithReuseIdentifier: K.iTunesCellIdentifier)
        NotificationCenter.default.addObserver(forName: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (notification) in
            print("AVPlayerItemDidPlayToEndTime")
//            self.currentPlayingItemButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.currentPlayingItemButton = nil
            self.collectionView.reloadData()
        }
        //Hide Autolayout Warning
//        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    // MARK: UICollectionView init
    
    func initCollectionViewFlowLayout(){
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout?.minimumLineSpacing = CGFloat(K.collectionLineSpacing)
        flowLayout?.minimumInteritemSpacing = CGFloat(K.collectionInteritemSpacing)
        let spacing = CGFloat(K.spacing)
        flowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return songList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function, indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.iTunesCellIdentifier, for: indexPath) as! iTunesCell
    
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(playButtonGroupAction(sender:)), for: .touchUpInside)

        if cell.playButton.tag == currentPlayingItemButton?.tag{
            cell.playButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        }else{
            cell.playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        cell.update(withSong: songList[indexPath.row], collectionView: collectionView, cell: cell, indexPath: indexPath)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
    
    //MARK: - play music function
    
    @objc func playButtonGroupAction(sender:UIButton){
        print(#function, sender.tag)
        currentPlayingItemButton?.setImage(UIImage(systemName: "play.circle"), for: .normal)
        
        if sender == currentPlayingItemButton{
            //stop play music
            iTunesController.shared.stopPlayMusic()
            currentPlayingItemButton = nil
            return
        }
        
        //play music with url
        guard let url = songList[sender.tag].previewUrl else {
            print("previewUrl fail")
            return
        }
        iTunesController.shared.playPreviewURL(url)
        sender.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        currentPlayingItemButton = sender
    }

}

//MARK: - UISearchResultsUpdating Delegate

extension iTunesCollectionViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text, searchString != "" else {
//            print("SearchBar.text is empty, do not search")
            return
        }
//        print("\(#function):\(searchString)")
        iTunesController.shared.fetchiTunesMusic(withSearch: searchString) { (result) in
            switch result{
            case .success(let songList):
                DispatchQueue.main.async {
                    self.songList = songList
                    self.collectionView.reloadData()
                }
            case .failure(let networkError):
                switch networkError {
                case .invalidUrl, .invalidData, .invalidResponse:
                    print(networkError)
                case .requestFailed(let error):
                    print(networkError, error)
                case .decodingError(let error):
                    print(networkError, error)
                }
            }
        }
    }
    
    func insertSearchBar(){
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.placeholder = "Search..."
//        definesPresentationContext = true
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
