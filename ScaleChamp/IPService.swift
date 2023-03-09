//
//  IPService.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//


protocol IPServiceDelegate {
    func loadIP() async throws  -> String
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
