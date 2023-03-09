//
//  ScaleChampApp.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//

import SwiftUI


protocol IPServiceDelegate {
    func loadIP() async throws  -> String
}

protocol HTTPClientDelegate {
    func request(url: String) async throws  -> String
}

class HTTPClient: HTTPClientDelegate {

    func request(url: String) async throws -> String {
        guard let url1 = URL(string: url) else { fatalError("Missing URL") }
        let (data, response) = try await URLSession.shared.data(from: url1)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

        return String(decoding: data, as: UTF8.self)
    }
}

class IPService: IPServiceDelegate {
    let httpClient: HTTPClientDelegate

    init(httpClient: HTTPClientDelegate) {
        self.httpClient = httpClient
    }

    func loadIP() async throws -> String {
        let url = try await self.httpClient.request(url: "https://ifconfig.me")
        return url
    }
}


class ScaleChampStore: ObservableObject {
    @Published var ip: String = ""


    let ipServiceDelegate: IPServiceDelegate
    
    init(ipServiceDelegate: IPServiceDelegate) {
        self.ipServiceDelegate = ipServiceDelegate
    }

    @MainActor
    func loadIP() async {
        do {
            self.ip = try await self.ipServiceDelegate.loadIP()
        } catch {
            print(error)
        }
    }
}

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
