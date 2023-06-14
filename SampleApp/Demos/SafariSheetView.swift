//
//  SafariSheetView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct SafariSheetView: View {
    @State var presentSafariView = false

    var body: some View {
        Button("Present Safari view") {
            presentSafariView.toggle()
        }
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $presentSafariView) {
            SafariView(url: URL(string: "https://q42.com")!)
        }
    }
}
