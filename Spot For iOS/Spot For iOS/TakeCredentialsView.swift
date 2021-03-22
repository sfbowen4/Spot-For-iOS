//
//  TakeCredentials.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 3/7/21.
//

import SwiftUI

struct TakeCredentialsView: View {
    
    @State var endpointHostname: String = "192.168.80.100"
    @State var hostPort: String = "8080"
    @State var spotIP: String = "192.168.80.3"
    @State var username: String = "Stephen"
    @State var password: String = "00113023Lms15"
    
    var body: some View {
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
            NavigationLink(
                destination: WalkingView(api: Api(endpointHostname: endpointHostname, hostPort: hostPort, spotIP: spotIP, username: username, password: password)),
                label: {
                    Text("Connect")
                })
        }
    }
}

