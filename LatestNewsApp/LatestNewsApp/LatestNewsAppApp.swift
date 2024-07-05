//
//  LatestNewsAppApp.swift
//  LatestNewsApp
//
//  Created by Mehmet Jiyan Atalay on 3.07.2024.
//

import SwiftUI
import SwiftData

@main
struct LatestNewsAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListScreen()
                    .preferredColorScheme(.light)
            }
        }.modelContainer(for: [DatabaseModel.self])
    }
}
