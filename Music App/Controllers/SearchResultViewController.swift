//
//  SearchResultViewController.swift
//  Music App
//
//  Created by Dowon Kim on 29/08/2023.
//

import UIKit

final class SearchResultViewController: UIViewController {

    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    //To hadle Music data - start with an empty array
    var musicArrays: [Music] = []
    
    //CollectionView Layout
    let flowLayout = UICollectionViewFlowLayout()
    
    // Network Manager - Singleton
    let networkManager = NetworkManager.shared
    
    // ❗️save searching keyword from SearchBar
    var searchTerm: String? {
        didSet {
            setupData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupData()
    }
    
    func setupCollectionView() {
        resultCollectionView.dataSource = self
        resultCollectionView.backgroundColor = .white
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWidth * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = CVCell.spacingWidth
        flowLayout.minimumLineSpacing = CVCell.spacingWidth
        
        resultCollectionView.collectionViewLayout = flowLayout
    }
    
    //Setup Data
    func setupData() {
        guard let term = searchTerm else { return print("fail!")}
        print("Networking keyword: \(term)")
        
        // make the array empty before begin Networking
        self.musicArrays = []
        
        // Begin Networking(with keywords)
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                // put results in the array
                self.musicArrays = musicDatas
                // Reload Collection View on main thread
                DispatchQueue.main.async {
                    self.resultCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        cell.imageUrl = musicArrays[indexPath.item].imageUrl
        return cell
    }
    
}
