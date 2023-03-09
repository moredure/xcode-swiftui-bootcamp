//
//  HTTPClient.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//

import Foundation

protocol HTTPClientDelegate {
    func request(url: String) async throws  -> String
}

class HTTPClient: HTTPClientDelegate {
    func request(url: String) async throws -> String {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        guard let url1 = URL(string: url) else { fatalError("Missing URL") }
        let (data, response) = try await URLSession.shared.data(from: url1)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

        return String(decoding: data, as: UTF8.self)
    }
}
