//
//  ScaleChampApp.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//

import SwiftUI

@main
struct ScaleChampApp: App {
    let scaleChampStore: ScaleChampStore

    init(scaleChampStore: ScaleChampStore) {
        self.scaleChampStore = scaleChampStore
    }

    init() {
        let httpClient = HTTPClient()
        let ipServiceDelegate = IPService(httpClient: httpClient)
        let scaleChampStore = ScaleChampStore(ipServiceDelegate: ipServiceDelegate)
        self.init(scaleChampStore: scaleChampStore)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(scaleChampStore: self.scaleChampStore)
        }
    }
}
