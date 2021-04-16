//
//  ContentView.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 2/5/21.
//

import SwiftUI

struct ContentView: View {
    
    func wrapper() -> Void {
        print("After")
    }
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 50) {
                Text("Provide your credentials to control Spot.")
                TakeCredentialsView()
            }.navigationBarTitle("Sign In", displayMode: .inline)
        }
    }
}
