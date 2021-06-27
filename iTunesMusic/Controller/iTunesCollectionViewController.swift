//
//  iTunesCollectionViewController.swift
//  iTunesMusic
//
//  Created by 方芸萱 on 2021/6/25.
//

import UIKit

class iTunesCollectionViewController: UICollectionViewController {
    
    var songList = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iTunes Music"
        insertSearchBar()
        initCollectionViewFlowLayout()
        collectionView.register(UINib(nibName: K.iTunesCellNibName, bundle: nil), forCellWithReuseIdentifier: K.iTunesCellIdentifier)
    }
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.iTunesCellIdentifier, for: indexPath) as! iTunesCell
    
        cell.update(withSong: songList[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate


}

extension iTunesCollectionViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
//        print("\(#function):\(searchString)")
        guard searchString != "" else { return }
        iTunesController.shared.fetchiTunesMusic(withSearch: searchString) { (songList) in
            if let songList = songList{
                DispatchQueue.main.async {
                    self.songList = songList
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func insertSearchBar(){
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = true
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.placeholder = "Search..."
        definesPresentationContext = true
        navigationItem.searchController = searchBar
    }
}
