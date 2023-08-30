//
//  ViewController.swift
//  Music App
//
//  Created by Dowon Kim on 28/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //🍎 Search Results Controller ⭐️
    //searchBar <-> navigationBar <-without this SearchResultViewController has no entry point.
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    @IBOutlet weak var musicTableView: UITableView!
    
    //Network Manager
    var networkManager = NetworkManager.shared
    
    //Start with an empty array(to handle the music datas)
    var musicArray: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        setupData()
    }
    
    //Setup for SearchBar
    func setupSearchBar() {
        self.title = "Music Title"
        navigationItem.searchController = searchController
        
        // 🍎 Search Results Controller ⭐️ ==> Search by characters + load new view
        searchController.searchResultsUpdater = self
        // Capitalization of first letter ==> off
        searchController.searchBar.autocapitalizationType = .none
    }
    
    //Setup for TableView
    func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        //For Nib file(Music Cell)
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    
    //Setup for data
    func setupData() {
        //Start Networking
        networkManager.fetchMusic(searchTerm: "blackpink") { result in
            print(#function)
            switch result {
            case .success(let musicDatas):
                //after GET Data(array)
                self.musicArray = musicDatas
                //Reload TableView
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print("\(error.localizedDescription) happened !")
            }
        }
    }
    

}

extension ViewController: UITableViewDataSource {
    
    //❗️stub 1/2
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicArray.count
    }
    
    //❗️stub 2/2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        cell.imageUrl = musicArray[indexPath.row].imageUrl
        cell.songNameLabel.text = musicArray[indexPath.row].songName
        cell.artistNameLabel.text = musicArray[indexPath.row].artistName
        cell.albumNameLabel.text = musicArray[indexPath.row].albumName
        cell.releaseDataLabel.text = musicArray[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//MARK: -  🍎 Search Results Controller ⭐️ ==> Showing spontanously (a word by word) while searching with keyword
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Word on SearchBar", searchController.searchBar.text ?? "")
        let vc = searchController.searchResultsController as! SearchResultViewController
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
