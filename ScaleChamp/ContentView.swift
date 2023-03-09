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
            if self.scaleChampStore.ip != nil {
                Text(self.scaleChampStore.ip!)
            } else if self.scaleChampStore.isLoading {
                Text("Is loading!")
            } else {
                Text("Hello, world!").onAppear {
                    Task {
                        await self.scaleChampStore.loadIP()
                    }
                }
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    class IPServiceMock: IPServiceDelegate {
        func loadIP() async  -> String {
            return "good bye"
        }
    }
    static var previews: some View {
        ContentView(scaleChampStore: ScaleChampStore(ipServiceDelegate: IPServiceMock()))
    }
}
