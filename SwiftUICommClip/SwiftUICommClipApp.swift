//
//  SwiftUICommClipApp.swift
//  SwiftUICommClip
//
//  Created by 孙梁 on 2021/12/22.
//

import SwiftUI

@main
struct SwiftUICommClipApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
