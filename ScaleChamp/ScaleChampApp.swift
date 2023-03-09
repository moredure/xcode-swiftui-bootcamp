//
//  ScaleChampApp.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//

import SwiftUI


protocol IPServiceDelegate {
    func loadIP() async  -> String
}

protocol HTTPClientDelegate {
    func request(url: String) async  -> String
}

class HTTPClient: HTTPClientDelegate {
    func request(url: String) async -> String {
        guard let url = URL(string: url) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        try! await Task.sleep(nanoseconds: 3_000_000_000)
        let (data, response) = try! await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        return String(decoding: data, as: UTF8.self)
    }
}

class IPService: IPServiceDelegate {
    let httpClient: HTTPClientDelegate

    init(httpClient: HTTPClientDelegate) {
        self.httpClient = httpClient
    }

    func loadIP() async -> String {
        let url = await self.httpClient.request(url: "https://ifconfig.me")
        return url
    }
}

@MainActor
class ScaleChampStore: ObservableObject {
    @Published var ip: String?

    @Published var isLoading: Bool = false

    let ipServiceDelegate: IPServiceDelegate
    
    init(ipServiceDelegate: IPServiceDelegate) {
        self.ipServiceDelegate = ipServiceDelegate
    }

    func loadIP() async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        self.ip = await self.ipServiceDelegate.loadIP()
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
