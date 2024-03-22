//
//  AlbumView.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 22/03/24.
//

import SwiftUI

struct Album: Hashable, Codable {
    let userId: Int
    let id: Int
    let title: String
}

class AlbumViewModel: ObservableObject {
    
    @Published var albums: [Album] = []
    var userId: Int
    
    init(userId: Int) {
        self.userId = userId
        fetch()
    }
    
    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums?userId=\(userId)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Decodificar JSON
            do {
                let albums = try JSONDecoder().decode([Album].self, from: data)
                DispatchQueue.main.async {
                    self?.albums = albums
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

struct AlbumView: View {
    
    let user: User
    @StateObject var viewModel: AlbumViewModel
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: AlbumViewModel(userId: user.id))
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Circle()
                    .foregroundColor(.random)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(user.initials)
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                Text(user.name)
                    .bold()
            }
            .padding()
          
            List {
                ForEach(viewModel.albums, id: \.self) { album in
                    NavigationLink(destination: PhotosView(album: album)) {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                            Label("", systemImage: "person.2.crop.square.stack")
                                .font(.title)
                            
                            Text(album.title)
                                .bold()
                        }
                        }.padding(3)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) 
        }
        .navigationTitle("Álbuns")
    }
}
