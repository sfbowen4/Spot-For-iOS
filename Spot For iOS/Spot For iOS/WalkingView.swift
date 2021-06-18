//
//  WalkingView.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/7/21.
//

import SwiftUI

struct WalkingView: View {
    
    @EnvironmentObject var api: Api
    
    // Main View
    var body: some View {
        VStack(spacing: 50) {
            WalkingControlsView().environmentObject(api)
                .padding(.all, 25)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .shadow(radius: 50)
            PersistentEStop().environmentObject(api)
                .padding(.all, 25)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .shadow(radius: 50)
        }.navigationBarTitle("Control Spot", displayMode: .inline)
        .onDisappear { api.genericMovement(request: "sit") } // Sit Spot when exiting the view
    }
}
