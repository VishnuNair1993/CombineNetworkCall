//
//  MovieViewModel.swift
//  NetworkCallUsingCombine
//
//  Created by Vishnu M Nair on 27/09/25.
//

import Foundation
import Combine
import SwiftUI

final class MovieViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    var cancellables: Set<AnyCancellable> = []
    
    func fetchMovie() {
        
        fetchMovies()
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print(".finished")
                }
            } receiveValue: {[weak self] movies in
                self?.movies = movies
            }.store(in: &cancellables)
        
    }
    
}
