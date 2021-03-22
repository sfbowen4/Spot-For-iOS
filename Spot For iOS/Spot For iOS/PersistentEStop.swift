//
//  PersistentEStop.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/6/21.
//

import SwiftUI

struct PersistentEStop: View {
    
    let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            Button(action: {
                //Action: Trigger EStop
                self.api.StopAPIRequest()
            }) {
                Image("stop-sign")
                    .resizable()
                    .frame(width: 130, height: 130, alignment: .leading)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            
            
            Button(action: {
                self.api.ClearStopAPIRequest()
                //Action: Clear EStop
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
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
        }
    }
}