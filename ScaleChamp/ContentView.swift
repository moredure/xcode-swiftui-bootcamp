//
//  ContentView.swift
//  ScaleChamp
//
//  Created by Mykhailo Faraponov on 9.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var scaleChampStore: ScaleChampStore

    init(scaleChampStore: ScaleChampStore) {
        self.scaleChampStore = scaleChampStore
    }

    var body: some View {
        VStack {
            if self.scaleChampStore.ip != "" {
                ScrollView {
                        ShareLink(item: self.scaleChampStore.ip) {
                            Label("My IP: " + self.scaleChampStore.ip, systemImage:  "square.and.arrow.up")
                        }.padding()
                }
                .refreshable(action: self.scaleChampStore.loadIP)
            } else {
                ProgressView()
                    .padding()
                    .task(self.scaleChampStore.loadIP)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    class IPServiceMock: IPServiceDelegate {
        func loadIP() async  -> String {
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            return "good bye"
        }
    }

    static var previews: some View {
        ContentView(scaleChampStore: ScaleChampStore(ipServiceDelegate: IPServiceMock()))
    }
}
