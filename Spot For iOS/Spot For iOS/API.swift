//
//  API.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 2/8/21.
//

// TODO: Add completions to remaining functions to check for server/Spot errors... Completion values are currently commented out for nonessential error checks
// TODO: Send requests as JSON to clean things up. Not sure if this will slow things down for the high volume request functions (genericMovementRequest() and setPoseRequest())

import Foundation
import SwiftUI

// Very simple response from server for error checking
// TODO: Evolve error checking to include Spot's current state (instead of True/False values for Success/Failure
struct Response: Codable {
    let value: Bool
}

// Api functions for communicating with server (which passes to Spot)
class Api: ObservableObject {
    
    var endpointHostname: String
    var hostPort: String
    var spotIP: String
    var username: String
    var password: String
    
    // Set values as empty strings
    // TODO: Make a better way of initializing the API on TakeCredentialsView
    init() {
        self.endpointHostname = ""
        self.hostPort = ""
        self.spotIP = ""
        self.username = ""
        self.password = ""
    }
    
    // Take in the credentials and robot circumstances.
    // TODO: See init() TODO
    func setCredentials(endpointHostname: String, hostPort: String, spotIP: String, username: String, password: String) {
        
        self.endpointHostname = endpointHostname
        self.hostPort = hostPort
        self.spotIP = spotIP
        self.username = username
        self.password = password
        
    }
    
    // End API connection to Spot and "sign out"
    func endConnection(completion: @escaping (Response) -> ()) {
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/EndConnection") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if (error == nil) {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedResponse)
                        }
                        return
                    }
                }
            }
            else {
                completion(Response(value: false))
                return
            }
        }.resume()
    }
    
    // Check user's credentials with Spot and "sign in"
    func authenticate(completion: @escaping (Response) -> ()) {
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/Auth?host=\(self.spotIP)&user=\(self.username)&pass=\(self.password)&timeout=60") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            semaphore.signal()
            if (error == nil) {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedResponse)
                        }
                        return
                    }
                }
            }
            else {
                completion(Response(value: false))
                return
            }
        }.resume()
        semaphore.wait()
    }
    
    // Power Spot on
    func togglePower(completion: @escaping (Response) -> ()) {
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/TogglePower") else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            semaphore.signal()
            if (error == nil) {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedResponse)
                        }
                        return
                    }
                }
            }
            else {
                completion(Response(value: false))
                return
            }
        }.resume()
        semaphore.wait()
    }
    
    // Trigger EStop
    func eStop(completion: @escaping (Response) -> ()) {
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/EStop") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if (error == nil) {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedResponse)
                        }
                        return
                    }
                }
            }
            else {
                completion(Response(value: false))
                return
            }
        }.resume()
    }
    
    // Clear EStop
    func clearEStop(completion: @escaping (Response) -> ()) {
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/ClearEStop") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if (error == nil) {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedResponse)
                        }
                        return
                    }
                }
            }
            else {
                completion(Response(value: false))
                return
            }
        }.resume()
    }
    
    // Send basic WASDQE and Sit/Stand movement requests to Spot
    func genericMovement(request: String) {
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/GenericMovementRequest?request=\(request)") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if (error == nil) {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            //completion(decodedResponse)
                        }
                        return
                    }
                }
            }
            else {
                //completion(Response(value: false))
                return
            }
        }.resume()
    }
    
    // Set Spot's pose based on yaw, roll, and pitch
    func setPose(yaw: Double, roll: Double, pitch: Double) {
        
        // Split the input values at the decimal for URL
        let yawParts = yaw.splitIntoParts()
        let rollParts = roll.splitIntoParts()
        let pitchParts = pitch.splitIntoParts()
        
        guard let url = URL(string: "http://\(self.endpointHostname):\(self.hostPort)/SetPose?yaw=\(yawParts.leftPart)%2E\(yawParts.rightPart)&roll=\(rollParts.leftPart)%2E\(rollParts.rightPart)&pitch=\(pitchParts.leftPart)%2E\(pitchParts.rightPart)") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { _,_,_ in
        }.resume()
    }
}

// Help transform yaw, roll, and pitch values into URL-friendly strings
// Split a Double at the decimal into two strings
extension Double {

    func splitIntoParts() -> (leftPart: String, rightPart: String) {

        let number = self
        // Convert to string and split on decimal point:
        let parts = String(number).components(separatedBy: ".")
        return (parts[0], parts[1])

    }
}
