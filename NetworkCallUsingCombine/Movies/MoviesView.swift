//
//  MoviesView.swift
//  NetworkCallUsingCombine
//
//  Created by Vishnu M Nair on 27/09/25.
//

import SwiftUI

struct MoviesView: View {
    
    @StateObject private var viewModel: MovieViewModel = MovieViewModel()
    
    var body: some View {
        
        List(viewModel.movies) { movie in
            
            HStack {
                AsyncImage(url: movie.posterURL) { poster in
                    poster
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                } placeholder: {
                    ProgressView()
                        .frame(width: 100)
                }
                
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.overview)
                        .font(.caption)
                        .lineLimit(3)
                }
            }.onAppear{
                print("movie.posterURL = \(String(describing: movie.posterURL))")
            }
            
        }.onAppear{
            viewModel.fetchMovie()
        }
        
    }
}

#Preview {
    MoviesView()
}
