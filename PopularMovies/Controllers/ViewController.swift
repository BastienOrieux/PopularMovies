//
//  ViewController.swift
//  PopularMovies
//
//  Created by ORIEUX Bastien on 10/3/19.
//  Copyright © 2019 Privalia. All rights reserved.
//

import UIKit

enum TypeList{
    case listMovie
    case searchMovie
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var typeList : TypeList = .listMovie
    var modelMovie : PopularMovieModel? = nil
    
    var apiKey = "93aea0c77bc168d8bbce3918cefefa45"
    var searchValue : String = ""
    var currentPage = 0
    var totalPages = 0
    
    var listMovie : [MovieModel] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.searchBar.showsScopeBar = false
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search movie by keyword"
        
        GetMovieList()
    }
    
    fileprivate func GetMovieList() {
        var params : [String:Any]
        var isSearch : Bool
        
        switch typeList {
        case .listMovie:
            params = getParamsList()
            isSearch = false
        case .searchMovie:
            params = getParamsSearch(search: searchValue)
            isSearch = true
        }
        
        NetworkManager.shared.getPopularMovies(params: params, isSearch: isSearch) { (modelMovie, result, error) in
            if result == 200 {
                self.modelMovie = modelMovie!
                self.currentPage = (modelMovie?.page)!
                self.totalPages = (modelMovie?.totalPages)!
                if let movies = modelMovie?.results{
                        self.listMovie.append(contentsOf: movies)
                    }
                
            }else if result == 401 || result == 404{
                print("\((error?.statusCode)!):\((error?.statusMessage)!)")
            }else{
                print("Server error")
            }
        }
    }
    
    func movieDate(index: NSInteger) -> String {
        if let releaseDate = listMovie[index].releaseDate as String? {
            guard !releaseDate.isEmpty else {
                return ""
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: releaseDate)
            dateFormatter.dateFormat = "yyyy"
            
            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    func getParamsList() -> [String: Any] {
        var urlParams = [String: Any]()
        urlParams["api_key"] = apiKey
        urlParams["page"] = currentPage + 1
        urlParams["language"] = "en-US"
        return urlParams
    }
    
    func getParamsSearch(search: String)-> [String:Any]{
        var urlParams = [String: Any]()
        urlParams["api_key"] = apiKey
        urlParams["page"] = currentPage + 1
        urlParams["query"] = search
        urlParams["include_adult"] = true
        return urlParams
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.movieTitle.text = listMovie[indexPath.row].title
        cell.movieRelease.text = movieDate(index: indexPath.row)
        cell.movieOverview.text = listMovie[indexPath.row].overview
        cell.setFrontPreview(listMovie[indexPath.row])
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)  {
        let lastElement = (listMovie.count) - 1
        if indexPath.row == lastElement {
            GetMovieList()
        }
    }
    
    fileprivate func reinitializeList() {
        listMovie = []
        currentPage = 0
        totalPages = 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
                reinitializeList()
                typeList = .listMovie
                GetMovieList()
                return
                }
        reinitializeList()
        typeList = .searchMovie
        searchValue = searchText.lowercased()
        GetMovieList()
    }
}

