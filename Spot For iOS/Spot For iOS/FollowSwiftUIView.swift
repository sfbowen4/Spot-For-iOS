//
//  FollowSwiftUIView.swift
//  Spot For iOS
//
//  Created by Noah Frew on 4/20/21.
//

import SwiftUI

class ProximityObserver {
    @objc func didChange(notification: NSNotification) {
        print("MyView::ProximityObserver.didChange")
        if let device = notification.object as? UIDevice {
            print(device.proximityState)
        }
    }
}

struct FollowSwiftUIView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var proximityObserver = ProximityObserver()
    
    var body: some View {
        VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image("stop-sign")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .leading)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear() {
            self.activateProximitySensor()
        }
        .onDisappear() {
            self.deactivateProximitySensor()
        }
    }
    
    func activateProximitySensor() {
        print("MyView::activateProximitySensor")
        UIDevice.current.isProximityMonitoringEnabled = true
        
        if UIDevice.current.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(proximityObserver, selector: #selector(proximityObserver.didChange), name: UIDevice.proximityStateDidChangeNotification, object: UIDevice.current)
        }
    }
    
    func deactivateProximitySensor() {
        print("MyView::deactivateProximitySensor")
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(proximityObserver, name: UIDevice.proximityStateDidChangeNotification, object: UIDevice.current)
    }
}

struct FollowSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FollowSwiftUIView()
    }
}
