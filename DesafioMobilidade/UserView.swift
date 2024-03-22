
//
//  UserView.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 22/03/24.
//


import SwiftUI

struct User: Hashable, Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        guard let firstInitial = components.first?.first, let lastInitial = components.last?.first else {
            return ""
        }
        return "\(firstInitial)\(lastInitial)"
    }
}

class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Decodificar JSON
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self?.users = users
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

struct UserView: View {
    
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
      
        VStack {
            List {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(destination: AlbumView(user: user)) {
                        HStack {
                            Circle()
                                .foregroundColor(.random)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(user.initials) // Usando as iniciais do usuário
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                            Text(user.name)
                                .bold()
                        }.padding(3)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) 
        }
        .navigationTitle("Usuários")
        .onAppear {
            viewModel.fetch()
        }
    }
}


extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
