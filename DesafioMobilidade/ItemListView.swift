//
//  ItemListView.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 21/03/24.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item] = []
    
    var body: some View {
        List {
            ForEach(items) { item in
                VStack(alignment: .leading) {
                    Text("PAT: \(item.pat)")
                    Text(item.apelido).bold()
                }
            }
        }
        .navigationTitle("Lista de Itens")
        Button(action: deleteAllItems) {
            Label("Apagar tudo", systemImage: "trash")
        }
    }
    
    private func deleteAllItems() {
        for item in items {
            modelContext.delete(item)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar após excluir todos os itens: \(error)")
        }
    }
}
/*
#Preview {
    ItemListView()
}
*/
