//
//  ContentView.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 21/03/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item] = []
    
    @State private var apelido: String = ""
    @State private var mostraAlerta: Bool = false
    @State private var mensagemAlerta: String = ""
    @State private var mostraSucesso: Bool = false
    @State private var numPAT: Int = 69
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
               
                    GeometryReader { geometry in
                        Label("PAT : \(numPAT)", systemImage: "person")
                            .font(.title)
                    }
                    
                    Group {
                        TextField("Apelido", text: $apelido)
                            .padding()
                            .onChange(of: apelido) {
                                self.mostraSucesso = false
                            }
                    }
                    
                    GeometryReader { geometry in
                        VStack{
                            Button(action: addItem)
                            {
                                Label("Salvar", systemImage: "square.and.arrow.down")
                            }.alert(isPresented: $mostraAlerta) {
                                Alert(title: Text("Erro"), message: Text(self.mensagemAlerta), dismissButton: .default(Text("OK")))
                            }
                        }
                        .frame(maxWidth: geometry.size.width, alignment: .center)
                    }
                    
                    Group {
                        if mostraSucesso {
                            Text("Apelido válido: \(apelido)")
                                .foregroundColor(.green)
                        }
                        NavigationLink(destination: ItemListView()) {
                            Label("Lista de Apelidos", systemImage: "list.bullet")
                        }
                    }
                }
                
                Group {
                    NavigationLink(destination: UserView()) {
                        Label("Navegar", systemImage: "network")
                    }
                }
                
            }
            .navigationTitle("Mobilidade")
        }
    }

    private func addItem() {
        withAnimation {
            self.mostraSucesso = false
            
            if self.validarApelido() {
                if items.contains(where: { $0.apelido == self.apelido }) {
                    self.mostraAlerta = true
                    self.mensagemAlerta = "O apelido já existe."
                } else {
                    self.mostraSucesso = true
                    let newItem = Item(pat: self.numPAT, apelido:  self.apelido, data: .now)
                    modelContext.insert(newItem)
                }
            } else {
                self.mostraAlerta = true
            }
        }
    }

    private func validarApelido() -> Bool {
        if apelido.count < 3 {
            mensagemAlerta = "O apelido deve ter pelo menos 3 caracteres."
            return false
        }
        
        if apelido.count > 20 {
            mensagemAlerta = "O apelido não pode ter mais de 20 caracteres."
            return false
        }
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9 ]*$")
        let range = NSRange(location: 0, length: apelido.utf16.count)
        if regex.firstMatch(in: apelido, options: [], range: range) == nil {
            mensagemAlerta = "O apelido deve conter apenas caracteres alfanuméricos."
            return false
        }
        
        return true
    }
}
/*
#Preview {
    ContentView()
}
*/
