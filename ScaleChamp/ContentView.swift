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
        print("init")
        self.scaleChampStore = scaleChampStore
    }

    var body: some View {
        ScrollView {
            if self.scaleChampStore.ip != "" {
                Text(self.scaleChampStore.ip).padding()
            } else {
                Text("Is loading!").padding()
            }
        }.refreshable {
            print("doing")
            await self.scaleChampStore.loadIP()
            print(Task.isCancelled)
        }.task {
            print("onAppear")
            await self.scaleChampStore.loadIP()
        }
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
