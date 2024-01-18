//
//  QRCodeScannerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 18/01/2024.
//

import SwiftUI

@available(iOS 15.0, *)
struct QRCodeScannerView: View {
    @State var scannedCode: String?
    @State var isAlertPresented = false

    var body: some View {
        QRCodeScanner { code in
            scannedCode = code
            isAlertPresented = true
        }
        .ignoresSafeArea()
        .alert("Scanned Code", isPresented: $isAlertPresented, presenting: scannedCode) { code in
            Button("OK") {
                isAlertPresented = false
            }
        } message: { code in
            Text(code)
        }
    }
}
