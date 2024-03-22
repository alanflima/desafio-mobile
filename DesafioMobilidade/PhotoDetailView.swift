//
//  PhotoDetailView.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 22/03/24.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        
        VStack{
            Section {
              
                Text(photo.title)
                        .font(.title)
                      
                
                URLImage(urlString: photo.url)
                    .padding(10)
                    .aspectRatio(contentMode: .fit)
                
                
               
            }
            
            Spacer()
            
        }.navigationTitle("Lembrança")

    }
}

