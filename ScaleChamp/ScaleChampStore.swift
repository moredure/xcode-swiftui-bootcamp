//
//  ScaleChampStore.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//

import Foundation

class ScaleChampStore: ObservableObject {
    @Published var ip: String = ""

    let ipServiceDelegate: IPServiceDelegate

    init(ipServiceDelegate: IPServiceDelegate) {
        self.ipServiceDelegate = ipServiceDelegate
    }

    @MainActor
    @Sendable
    func loadIP() async -> Void {
        do {
            self.ip = try await self.ipServiceDelegate.loadIP()
        } catch {
            print(error)
        }
    }
}
