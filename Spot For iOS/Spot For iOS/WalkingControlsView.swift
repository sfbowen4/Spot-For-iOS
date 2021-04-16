//
//  WalkingControls.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/7/21.
//

import SwiftUI

class WASD {
    
    let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    func W() -> Void {
        self.api.genericAPIRequest(request: "W")
    }
    
    func A() -> Void {
        self.api.genericAPIRequest(request: "A")
    }
    
    func S() -> Void {
        self.api.genericAPIRequest(request: "S")
    }
    
    func D() -> Void {
        self.api.genericAPIRequest(request: "D")
    }
    
    func Q() -> Void {
        self.api.genericAPIRequest(request: "Q")
    }
    
    func E() -> Void {
        self.api.genericAPIRequest(request: "E")
    }
    
    func Sit() -> Void {
        self.api.genericAPIRequest(request: "sit")
    }
    
    func Stand() -> Void {
        self.api.genericAPIRequest(request: "stand")
    }
}

struct WalkingControlsView: View {
    
    let api: Api
    let wasd: WASD
    @State var standing = false
    @State var loop = false
    
    init(api: Api) {
        self.api = api
        self.wasd = WASD(api: self.api)
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
        
            HStack(spacing: 20) {
                
                MovementButton(buttonFunction: self.wasd.Q, buttonType: Image(systemName: "arrow.turn.up.left"))
                MovementButton(buttonFunction: self.wasd.W, buttonType: Image(systemName: "arrow.up"))
                MovementButton(buttonFunction: self.wasd.E, buttonType: Image(systemName: "arrow.turn.up.right"))
                
            }
            
            HStack(spacing: 20) {
                
                MovementButton(buttonFunction: self.wasd.A, buttonType: Image(systemName: "arrow.left"))
            
                Button(action: {
                    if (!standing) {
                        self.wasd.Stand()
                        standing.toggle()
                    }
                    else {
                        self.wasd.Sit()
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
                
                MovementButton(buttonFunction: self.wasd.D, buttonType: Image(systemName: "arrow.right"))
                
            }
            
            MovementButton(buttonFunction: self.wasd.S, buttonType: Image(systemName: "arrow.down"))
            
        }.font(.system(size: 60))
    }
}

