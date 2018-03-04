//
//  Movie.swift
//  Flix
//
//  Created by Andy Duong on 3/1/18.
//  Copyright © 2018 Andy Duong. All rights reserved.
//

import Foundation

class Movie {
    
    // MARK: Properties
    
    // TODO: Do we need to initialize the optional properties?
    
    var title: String
    var overview: String
    let baseURLStr = "https://image.tmdb.org/t/p/w500"
    var posterPathStr: String?
    var posterURL: URL?
    var backdropPathStr: String?
    var backdropURL: URL?
    var releaseDate: String
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as? String ?? "No overview"
        posterPathStr = dictionary["poster_path"] as? String
        posterURL = URL(string: baseURLStr + posterPathStr!)!
        backdropPathStr = dictionary["backdrop_path"] as? String
        backdropURL = URL(string: baseURLStr + backdropPathStr!)!
        releaseDate = dictionary["release_date"] as? String ?? "No release date"
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
