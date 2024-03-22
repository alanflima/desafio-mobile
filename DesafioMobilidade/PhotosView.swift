//
//  PhotosView.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 22/03/24.
//



import SwiftUI

struct Photo: Hashable, Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

class PhotoViewModel: ObservableObject {
    
    @Published var photos: [Photo] = []
    var albumId: Int
    
    init(albumId: Int) {
        self.albumId = albumId
        fetch()
    }
    
    func fetch() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Decodificar JSON
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                DispatchQueue.main.async {
                    self?.photos = photos
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}


struct PhotosView: View {
    
    let album: Album
    @StateObject var viewModel: PhotoViewModel
    
    init(album: Album) {
        self.album = album
        self._viewModel = StateObject(wrappedValue: PhotoViewModel(albumId: album.id))
    }
    
    
    var body: some View {
        
        VStack {
            HStack {
               
                Label("", systemImage: "person.2.crop.square.stack")
                    .font(.title)
                
                VStack(alignment: .leading) {
                        Text("Album de Fotos")
                        Text(album.title)
                            .bold()
                    }.padding(3)
                }
            
            .padding()
          
            List {
                ForEach(viewModel.photos, id: \.self) { photo in
                    NavigationLink(destination: PhotoDetailView(photo: photo)) {
                        HStack {
                            URLImage(urlString: photo.thumbnailUrl)
                                .padding(.trailing, 10)
                                .frame(width: 90, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(photo.title)
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.vertical, 8)
                    }
                }

            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Fotos")
        
        
    }
    
}

