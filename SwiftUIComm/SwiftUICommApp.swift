//
//  SwiftUICommApp.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI
import SLIKit

@main
struct SwiftUICommApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    @State private var firstIn = true
    @ObservedObject private var shared = AccountServicer.shared
    
    var body: some Scene {
        WindowGroup {
            Tabbar()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(shared)
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                print("App is active")
                config()
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            default:
                print("Oh - interesting: I received an unexpected new value.")
            }
        }
    }
}

extension SwiftUICommApp {
    func config() {
        guard firstIn else { return }
        self.firstIn = false
        SLHUD.loadingColor(Color.accentColor.toUIColor(), maskColor: .clear)
    }
}
