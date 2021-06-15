//
//  TakeCredentials.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 3/7/21.
//
//

import SwiftUI

struct TakeCredentialsView: View {

    @State var isActive: Bool = false
    @State var authenticating = false
    @State var showingAlert = false
    @State var endpointHostname: String = ""
    @State var hostPort: String = ""
    @State var spotIP: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @StateObject var api = Api()
    let backgroundQueue = DispatchQueue(label: "com.sfbowen4.Spot-For-iOS.queue")
    
    // Pass credentials to Api object and attempt authentication with Spot
    func signIn() {
        api.setCredentials(endpointHostname: self.endpointHostname, hostPort: self.hostPort, spotIP: self.spotIP, username: self.username, password: self.password)
        api.authenticate() { decodedResponse in
            self.isActive = decodedResponse.value
            self.showingAlert = !decodedResponse.value
        }
    }
    
    // Main View
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Server Address", text: $endpointHostname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                TextField("Server Port", text: $hostPort)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                TextField("Spot's Address", text: $spotIP)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                Button(action: {
                    backgroundQueue.async {
                        authenticating.toggle()
                        signIn()
                        authenticating.toggle()
                    }
                }) {
                    HStack() {
                        if(!authenticating) {
                            Image(systemName: "lock.open")
                            Text("Sign In").fontWeight(.semibold)
                        }
                        else {
                            Spinner(isAnimating: true, style: .large, color: .white)
                        }
                    }
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.blue))
                }.padding(.top, 40)
                NavigationLink(destination: SelectModeSwiftUIView().environmentObject(api), isActive: $isActive) {}
            }.navigationBarTitle("Sign In", displayMode: .inline)
            .alert(isPresented: $showingAlert) { Alert(title: Text("Sign In Error"), message: Text("There was an error signing into Spot. Please try again.")) }
        }
    }
}
