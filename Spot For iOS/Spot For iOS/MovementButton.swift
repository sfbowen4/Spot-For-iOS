//
//  MovementButton.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 4/15/21.
//

import SwiftUI

// Special button view to allow for long pressing to loop function
struct MovementButton: View {
    
    @State private var timer: Timer?
    @State var isLongPressing = false
    let buttonType: Image
    let buttonFunction: () -> Void
    
    init (buttonFunction: @escaping () -> Void, buttonType: Image) {
        self.buttonFunction = buttonFunction
        self.buttonType = buttonType
    }
    
    // Main View
    var body: some View {
        
        Button(action: {
            // Immediately call the buttonFunction before looping
            buttonFunction()
            // Check if long pressing and enter long press loop
            if(self.isLongPressing){
                self.isLongPressing.toggle()
                self.timer?.invalidate()
                
            } else {
                buttonFunction()
            }
        }, label: {
            buttonType
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(Capsule().fill(Color.blue))
        })
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.0).onEnded { _ in
            self.isLongPressing = true
            
            // Set interval time for looping function call
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
                buttonFunction()
            })
        })
    }
}
