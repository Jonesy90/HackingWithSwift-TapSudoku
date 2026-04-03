//
//  ContentView.swift
//  HackingWithSwift-TapSudoku
//
//  Created by Michael Jones on 03/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var bard = Board()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
