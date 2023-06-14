//
//  DeviceShakeView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 14/06/2023.
//

import SwiftUI

struct DeviceShakeView: View {
    @State var didShake = false

    var body: some View {
        ZStack {
            if didShake {
                Rectangle()
                    .fill(.red)
                    .ignoresSafeArea()

                Text("Shake detected!")
            } else {
                Text("Shake your device.")
            }
        }
        .onShake {
            print("Shaked device!")
            withAnimation {
                didShake = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    didShake = false
                }
            }
        }
    }
}

struct DeviceShakeView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceShakeView()
    }
}
