//
//  API.swift
//  SpotEStop
//
//  Created by Stephen Bowen on 2/8/21.
//

import Foundation

class Api {
    
    var endpointHostname: String
    var hostPort: String
    var spotIP: String
    var username: String
    var password: String
    
    init(endpointHostname: String, hostPort: String, spotIP: String, username: String, password: String) {
        
        //Take in the credentials and robot circumstances.
        self.endpointHostname = endpointHostname
        self.hostPort = hostPort
        self.spotIP = spotIP
        self.username = username
        self.password = password
        
    }
    
    func refreshCredentials(endpointHostname: String, hostPort: String, spotIP: String, username: String, password: String) {
        
        //End previous connection
        endConnection()
        
        //Take in the credentials and robot circumstances.
        self.endpointHostname = endpointHostname
        self.hostPort = hostPort
        self.spotIP = spotIP
        self.username = username
        self.password = password
        
        //Initialize new connection to robot
        StartAPIRequest()
    }
    
    func endConnection() {
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/End") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            _ = try! JSONDecoder().decode(String.self, from: data!)
            DispatchQueue.main.async {
            }
        }
        .resume()
    }
    
    func StartAPIRequest() {
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/start?host=\(self.spotIP)&user=\(self.username)&pass=\(self.password)&timeout=60") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            _ = try! JSONDecoder().decode(String.self, from: data!)
            DispatchQueue.main.async {
            }
        }
        .resume()
    }
    
    func StopAPIRequest() {
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/stop") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            _ = try! JSONDecoder().decode(String.self, from: data!)
            DispatchQueue.main.async {
            }
        }
        .resume()
    }
    
    func ClearStopAPIRequest() {
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/ClearStop") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            _ = try! JSONDecoder().decode(String.self, from: data!)
            DispatchQueue.main.async {
            }
        }
        .resume()
    }
    
    func HelloAPIRequest() {
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/Hello") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            _ = try! JSONDecoder().decode(String.self, from: data!)
            DispatchQueue.main.async {
            }
        }
        .resume()
    }
    
    func genericAPIRequest(request: String) {
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/GenericRequest?request=\(request)") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            _ = try! JSONDecoder().decode(String.self, from: data!)
            DispatchQueue.main.async {
            }
        }
        .resume()
    }
}
