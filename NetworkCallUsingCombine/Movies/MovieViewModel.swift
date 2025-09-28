//
//  MovieViewModel.swift
//  NetworkCallUsingCombine
//
//  Created by Vishnu M Nair on 27/09/25.
//

import Foundation
import Combine
import SwiftUI


/*
 .map { searchQuery in searchMovies(...) }
 Transforms each search string into a new publisher (AnyPublisher<MovieResponse, Error>).
 So at this point, your stream is actually a publisher of publishers.
 
 .switchToLatest()
 Flattens that “publisher of publishers” into a single stream.
 Importantly: if the user types again before the previous request finishes, the old request is cancelled.
 (This is the behavior you usually want in search.)
 
 .map(\.results)
 Extracts [Movie] from the MovieResponse.
 ------------------------------------------------------------------------------------------------------------
 .flatMap { query in
     searchMovies(query: query)
         .catch { _ in Just(MovieResponse(results: [])) }
 }
 .map(\.results)

 The difference:
 flatMap → allows multiple requests to run at the same time (results may arrive out of order).
 switchToLatest → always cancels the previous one and keeps only the latest request active (perfect for search).
 That’s why .map { … }.switchToLatest() is a better fit for search/autocomplete.
 */


final class MovieViewModel: ObservableObject {
    
    @Published var upcomingMovies: [Movie] = []
    var cancellables: Set<AnyCancellable> = []
    
    @Published var searchQuery: String = ""
    @Published var searchResults: [Movie] = []
    
    var movies: [Movie] {
        if searchQuery.isEmpty {
            upcomingMovies
        }else{
            searchResults
        }
    }
    
    init(){
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { searchQuery in
                searchMovies(query: searchQuery) //Transforms each search string into a new publisher (AnyPublisher<MovieResponse,     Error>).So at this point, your stream is actually a publisher of publishers.
            }.switchToLatest()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink {[weak self] movies in
                self?.searchResults = movies
            }.store(in: &cancellables)
    }
    
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
                self?.upcomingMovies = movies
            }.store(in: &cancellables)
        
    }
    
}
