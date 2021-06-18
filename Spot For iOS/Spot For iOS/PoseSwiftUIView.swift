//
//  PoseSwiftUIView.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 6/9/21.
//

import SwiftUI
import CoreMotion

struct PoseSwiftUIView: View {
    
    @EnvironmentObject var api: Api
    @State var yaw: Double = 0.0
    @State var roll: Double = 0.0
    @State var pitch: Double = 0.0
    let manager = CMMotionManager()
    
    // Start reading attitude data from iOS device
    func readAttitude() {
        manager.deviceMotionUpdateInterval = 0.1 // 10hz refresh rate for updating attitude readings -- TODO: Add ability to dynamically change refresh rate in app (maybe a slider)
        manager.startDeviceMotionUpdates(to: .main) { (motion, error) in
            self.pitch = (motion!.attitude.pitch * -1) // Flip to negative to match Spot's input
            self.roll = motion!.attitude.roll
            self.yaw = motion!.attitude.yaw
        }
    }
    
    // Stop reading attitude data from iOS device
    func stopReadingAttitude() {
        manager.stopDeviceMotionUpdates()
    }

    // Main View
    var body: some View {
        VStack(spacing: 15) {
            
            // Buttons for starting and stopping attitude data stream
            Button(action: { readAttitude() }) {
                Text("Read Attitude")
            }
            Button(action: { stopReadingAttitude() }) {
                Text("Stop Reading Attitude")
            }
            
            // Sliders for manual adjustment
            VStack {
                Slider(value: $yaw, in: -1...1, step: 0.15).onChange(of: yaw) { newValue in api.setPose(yaw: yaw, roll: roll, pitch: pitch) }
                Slider(value: $roll, in: -1...1, step: 0.15).onChange(of: roll) { newValue in api.setPose(yaw: yaw, roll: roll, pitch: pitch) }
                Slider(value: $pitch, in: -1...1, step: 0.15).onChange(of: pitch) { newValue in api.setPose(yaw: yaw, roll: roll, pitch: pitch) }
            }.padding(25)
            
            // EStop
            PersistentEStop().environmentObject(api)
                .padding(.all, 25)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .shadow(radius: 50)
            
        }.navigationBarTitle("Set Pose", displayMode: .inline)
        .onAppear { api.genericMovement(request: "stand") }
        .onDisappear { api.genericMovement(request: "sit") }
    }
}
