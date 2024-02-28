//
//  PrintButtonView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PrintButtonView: View {
    var body: some View {
        PrintButton(url: Bundle.main.url(forResource: "sample", withExtension: "pdf")) {
            Label("Print", systemImage: "printer")
        }
    }
}

#Preview {
    PrintButtonView()
}
