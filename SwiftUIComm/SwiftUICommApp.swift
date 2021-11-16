//
//  SwiftUICommApp.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

@main
struct SwiftUICommApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Tabbar()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(AccountServicer.shared)
        }
    }
}
