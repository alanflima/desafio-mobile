
//
//  Item.swift
//  DesafioMobilidade
//
//  Created by Alan Lima on 21/03/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var pat: Int
    var apelido: String
    var data :Date
    init(pat: Int = 69, apelido: String = "", data: Date = .now) {
        self.pat = pat
        self.apelido = apelido
        self.data = data
    }
    
}
