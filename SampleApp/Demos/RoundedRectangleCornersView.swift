//
//  RoundedRectangleCornersView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct RoundedRectangleCornersView: View {
    var body: some View {
        Button("Hello world") {}
            .buttonStyle(RoundedCornerButtonStyle())
            .padding()
    }
}

struct RoundedCornerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(configuration.isPressed ? 0.5 : 1.0))
            .cornerRadius(8, corners: [.topLeft, .bottomLeft, .topRight])
    }
}

struct RoundedRectangleCornersView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleCornersView()
    }
}
