//
//  WalkingView.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/7/21.
//

import SwiftUI

struct WalkingView: View {
    
    let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                WalkingControlsView(api: api)
                    .padding(.all, 25)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .shadow(radius: 50)
                PersistentEStop(api: api)
                    .padding(.all, 25)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .shadow(radius: 50)
            }
        }.navigationBarTitle("Control Spot", displayMode: .inline)
        .onAppear {
            self.api.StartAPIRequest()
        }
        .onDisappear() {
            self.api.endConnection()
        }
    }
}
