//
//  SelectModeSwiftUIView.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 6/9/21.
//

import SwiftUI

struct SelectModeSwiftUIView: View {
    
    @EnvironmentObject var api: Api
    @State var tag:Int? = nil
    @State var poweredOn: Bool = false
    @State var togglingPower: Bool = false
    @State var showingAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let backgroundQueue = DispatchQueue(label: "com.sfbowen4.Spot-For-iOS.queue")
    
    // TODO: Make a more graceful way to power off Spot during sign off
    // Power off, "sign out" of Spot, and close the view
    func signOut() {
        if (poweredOn == true) {
            api.togglePower() { decodedResposne in
                poweredOn = decodedResposne.value
            }
        }
        api.endConnection() { decodedResponse in }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    // Main View
    var body: some View {
        VStack {
            ZStack {
                    Button(action: {
                        backgroundQueue.async {
                            togglingPower.toggle()
                            api.togglePower() { decodedResposne in
                                showingAlert = (decodedResposne.value != poweredOn) ? false : true // Check for successful toggle of power
                                poweredOn = decodedResposne.value // Set power status
                            }
                            togglingPower.toggle()
                        }
                    }) {
                        HStack() {
                            if(!togglingPower) {
                                Image(systemName: poweredOn ? "bolt.fill" : "bolt")
                                Text(poweredOn ? "Power Off" : "Power On").fontWeight(.semibold)
                            }
                            else {
                                Spinner(isAnimating: true, style: .large, color: .white)
                            }
                                }
                            .font(.title)
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(poweredOn ? Color.red : Color.green))
                    }.padding(.top, 40)
                }
            ZStack {
                  NavigationLink(destination: WalkingView().environmentObject(api), tag: 1, selection: $tag) {
                    EmptyView()
                  }
                    Button(action: {
                        self.tag = 1
                    }) {
                        HStack() {
                                Image(systemName: "figure.walk")
                                Text("Walk")
                                    .fontWeight(.semibold)
                                }
                            .font(.title)
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.blue))
                            .opacity(poweredOn ? 1 : 0.5)
                    }.padding(.top, 40)
                    .disabled(poweredOn == false)
                }
            ZStack {
                  NavigationLink(destination: PoseSwiftUIView().environmentObject(api), tag: 2, selection: $tag) {
                    EmptyView()
                  }
                    Button(action: {
                        self.tag = 2
                    }) {
                        HStack() {
                                Image(systemName: "figure.wave")
                                Text("Pose")
                                    .fontWeight(.semibold)
                                }
                            .font(.title)
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.blue))
                            .opacity(!poweredOn ? 0.5 : 1)
                    }.padding(.top, 40)
                    .disabled(poweredOn == false)
                }
        }.navigationBarTitle("Select Mode", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: { signOut() }) { Image(systemName: "lock").frame(width: 60, height: 60).font(.title)})
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingAlert) { Alert(title: Text("Power Error"), message: Text("There was an powering on Spot. Please try again.")) }
    }
}
