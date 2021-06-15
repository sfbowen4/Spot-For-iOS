//
//  WalkingControls.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/7/21.
//

import SwiftUI

// Collection of generic movement functions to simplifying view
struct WASD {
    
    let api: Api
    
    func W() -> Void {
        self.api.genericMovement(request: "W")
    }
    
    func A() -> Void {
        self.api.genericMovement(request: "A")
    }
    
    func S() -> Void {
        self.api.genericMovement(request: "S")
    }
    
    func D() -> Void {
        self.api.genericMovement(request: "D")
    }
    
    func Q() -> Void {
        self.api.genericMovement(request: "Q")
    }
    
    func E() -> Void {
        self.api.genericMovement(request: "E")
    }
    
    func Sit() -> Void {
        self.api.genericMovement(request: "sit")
    }
    
    func Stand() -> Void {
        self.api.genericMovement(request: "stand")
    }
}

struct WalkingControlsView: View {
    
    @EnvironmentObject var api: Api
    @State var standing = false
    @State var loop = false
    
    // Main View
    var body: some View {
        
        let wasd = WASD(api: api)
        
        VStack(spacing: 20) {
        
            HStack(spacing: 20) {
                
                MovementButton(buttonFunction: wasd.Q, buttonType: Image(systemName: "arrow.turn.up.left"))
                MovementButton(buttonFunction: wasd.W, buttonType: Image(systemName: "arrow.up"))
                MovementButton(buttonFunction: wasd.E, buttonType: Image(systemName: "arrow.turn.up.right"))
                
            }
            
            HStack(spacing: 20) {
                
                MovementButton(buttonFunction: wasd.A, buttonType: Image(systemName: "arrow.left"))
            
                Button(action: {
                    if (!standing) {
                        wasd.Stand()
                        standing.toggle()
                    }
                    else {
                        wasd.Sit()
                        standing.toggle()
                    }
                }) {
                    HStack {
                        if (standing) {
                            Image(systemName: "bed.double")
                        }
                        else {
                            Image(systemName: "figure.stand")
                        }
                            }
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }
                
                MovementButton(buttonFunction: wasd.D, buttonType: Image(systemName: "arrow.right"))
                
            }
            
            MovementButton(buttonFunction: wasd.S, buttonType: Image(systemName: "arrow.down"))
            
        }.font(.system(size: 60))
    }
}

