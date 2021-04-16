//
//  MovementButton.swift
//  Spot For iOS
//
//  Created by Stephen Bowen on 4/15/21.
//

import SwiftUI

struct MovementButton: View {
    
    @State private var timer: Timer?
    @State var isLongPressing = false
    let buttonType: Image
    let buttonFunction: () -> Void
    
    init (buttonFunction: @escaping () -> Void, buttonType: Image) {
        self.buttonFunction = buttonFunction
        self.buttonType = buttonType
    }
    
    var body: some View {
        
        Button(action: {
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
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
            self.isLongPressing = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { _ in
                buttonFunction()
            })
        })
    }
}
