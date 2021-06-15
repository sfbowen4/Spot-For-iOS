//
//  PersistentEStop.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/6/21.
//

import SwiftUI

struct PersistentEStop: View {
    
    @EnvironmentObject var api: Api
    
    // Main View
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(action: {
                // Trigger EStop
                self.api.eStop() { decodedResponse in }
            }) {
                Image("stop-sign")
                    .resizable()
                    .frame(width: 130, height: 130, alignment: .leading)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            
            VStack {
                NavigationLink(
                    destination: FollowSwiftUIView(),
                    label: {
                        HStack {
                            Text("Follow")
                                .fontWeight(.semibold)
                        }
                        .font(.title)
                        .frame(width: 150, height: 30)
                        .foregroundColor(.blue)
                        .padding(.vertical, 15)
                        .background(Capsule().fill(Color.white))
                    })
                
                Button(action: {
                    // Clear EStop
                    self.api.clearEStop() { decodedResponse in }
                }) {
                    HStack {
                        Text("Clear Stop")
                            .fontWeight(.semibold)
                    }
                    .font(.title)
                    .frame(width: 150, height: 30)
                    .foregroundColor(.blue)
                    .padding(.vertical, 15)
                    .background(Capsule().fill(Color.white))
                }
            }
        }
    }
}
