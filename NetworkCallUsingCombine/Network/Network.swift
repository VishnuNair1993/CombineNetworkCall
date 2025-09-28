//
//  Network.swift
//  NetworkCallUsingCombine
//
//  Created by Vishnu M Nair on 27/09/25.
//

import Foundation
import Combine

let apiKey = "da9bc8815fb0fc31d5ef6b3da097a009"
let baseUrl = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")


//AnyPublisher makes long, messy publisher types look short and simple

func fetchMovies() -> AnyPublisher<MovieResponse, Error>{
    
    URLSession
        .shared
        .dataTaskPublisher(for: baseUrl!)
        .map(\.data)
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
        .eraseToAnyPublisher()
  
}
