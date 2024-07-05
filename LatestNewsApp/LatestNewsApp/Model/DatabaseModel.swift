//
//  DatabaseModel.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 4.07.2024.
//

import Foundation
import SwiftData

@Model
class DatabaseModel : Identifiable {
    let id: UUID = UUID()
    var newId : Int
    
    init(newId: Int) {
        self.newId = newId
    }
}
