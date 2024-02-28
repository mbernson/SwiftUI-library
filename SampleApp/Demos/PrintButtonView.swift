//
//  PrintButtonView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PrintButtonView: View {
    var body: some View {
        PrintButton(image: UIImage(systemName: "globe")) {
            Label("Print", systemImage: "printer")
        }
    }
}

#Preview {
    PrintButtonView()
}
