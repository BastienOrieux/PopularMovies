//
//  NetworkManager.swift
//  PopularMovies
//
//  Created by ORIEUX Bastien on 10/3/19.
//  Copyright © 2019 Privalia. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkManager: NSObject {
    public static let shared = NetworkManager()
    let baseUrl = "https://api.themoviedb.org/3"
    
    public func getPopularMovies(params: [String: Any]?, isSearch: Bool, completion: @escaping (PopularMovieModel?, Int?, errorModel?) -> ())  {
        var urlResult = baseUrl
        
        if isSearch{
           urlResult = urlResult + "/search/movie"
        }else{
            urlResult = urlResult + "/movie/popular"
        }
    
        Alamofire.request(urlResult, method: .get, parameters: params, headers: nil).responseJSON { response in
            print(response)
            do {
                if response.response?.statusCode == 200 {
                    if let popularMovieJSON = (response.result.value as? [String : Any]) {
                        let jsonMoviesData = try JSONSerialization.data(withJSONObject: popularMovieJSON, options: .prettyPrinted)
                        let reqJSONStr = String(data: jsonMoviesData, encoding: .utf8)
                        if let data = reqJSONStr?.data(using: .utf8) {
                            let movies = try JSONDecoder().decode(PopularMovieModel.self, from: data)
                            completion(movies, 200, nil)
                            return
                        }
                    }
                }else if response.response?.statusCode == 401 {
                    if let errorJSON = (response.result.value as? [String : Any]) {
                        let errorData = try JSONSerialization.data(withJSONObject: errorJSON, options: .prettyPrinted)
                        let reqJSONStr = String(data: errorData, encoding: .utf8)
                        if let data = reqJSONStr?.data(using: .utf8) {
                            let error = try JSONDecoder().decode(errorModel.self, from: data)
                            completion(nil, 401, error)
                            return
                        }
                    }
                }else if response.response?.statusCode == 404 {
                    if let errorJSON = (response.result.value as? [String : Any]) {
                        let errorData = try JSONSerialization.data(withJSONObject: errorJSON, options: .prettyPrinted)
                        let reqJSONStr = String(data: errorData, encoding: .utf8)
                        if let data = reqJSONStr?.data(using: .utf8) {
                            let error = try JSONDecoder().decode(errorModel.self, from: data)
                            completion(nil, 404, error)
                            return
                        }
                    }
                }else {
                    completion(nil, response.response?.statusCode, nil)
                    return
                }
            }catch{
                print("Unexpected error: \(error).")
                completion(nil,nil,nil)
                }
            }
        }
    
   
    func loadImage(path: String, completion: @escaping (UIImage?) -> ()) {
        let url = "https://image.tmdb.org/t/p/w500"
        let request = url + path
        
        Alamofire.request(request).responseData { response in
            if let data = response.data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(UIImage())
            }
        }
    }
    
    
    
    }


