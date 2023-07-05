//
//  QRCodeView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 04/07/2023.
//

import SwiftUI

struct QRCodeView: View {
    var body: some View {
        QRCodeImage(url: URL(string: "https://q42.nl/")!)
            .padding()
            .increasedScreenBrightness()
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
