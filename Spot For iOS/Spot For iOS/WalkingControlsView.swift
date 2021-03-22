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
    
    func W() {
        self.api.genericAPIRequest(request: "W")
    }
    
    func A() {
        self.api.genericAPIRequest(request: "A")
    }
    
    func S() {
        self.api.genericAPIRequest(request: "S")
    }
    
    func D() {
        self.api.genericAPIRequest(request: "D")
    }
    
    func Q() {
        self.api.genericAPIRequest(request: "Q")
    }
    
    func E() {
        self.api.genericAPIRequest(request: "E")
    }
    
    func Sit() {
        self.api.genericAPIRequest(request: "sit")
    }
    
    func Stand() {
        self.api.genericAPIRequest(request: "stand")
    }
}

struct WalkingControlsView: View {
    
    let api: Api
    let wasd: WASD
    @State var standing = false
    
    init(api: Api) {
        self.api = api
        self.wasd = WASD(api: self.api)
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
        
            HStack(spacing: 20) {
                
                Button(action: {
                    //Left Turn
                    self.wasd.Q()
                }) {
                    HStack {
                            Image(systemName: "arrow.turn.up.left")
                            }
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }
            
                Button(action: {
                    //Forward
                    self.wasd.W()
                }) {
                    HStack {
                        Image(systemName: "arrow.up")
                            }
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }.onLongPressGesture(minimumDuration: 0.0, pressing: { (isPressing) in
                }, perform: {
                    self.wasd.W()
                })
                
                Button(action: {
                    //Right Turn
                    self.wasd.E()
                }) {
                    HStack {
                            Image(systemName: "arrow.turn.up.right")
                            }
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }
            }
            
            HStack(spacing: 20) {
                
                Button(action: {
                    //Left Strafe
                    self.wasd.A()
                }) {
                    HStack {
                            Image(systemName: "arrow.left")
                            }
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }
            
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
                
                Button(action: {
                    //Right Strafe
                    self.wasd.D()
                }) {
                    HStack {
                            Image(systemName: "arrow.right")
                            }
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }
            }
            
            Button(action: {
                //Backwards
                self.wasd.S()
            }) {
                HStack {
                        Image(systemName: "arrow.down")
                        }
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color.blue))
            }
        }.font(.system(size: 60))
    }
}

