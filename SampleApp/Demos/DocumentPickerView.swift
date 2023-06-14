//
//  DocumentPickerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct DocumentPickerView: View {
    @State var presentDocumentPicker = false

    var body: some View {
        Button("Present document picker") {
            presentDocumentPicker.toggle()
        }
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $presentDocumentPicker) {
            DocumentPicker(contentTypes: [.image, .video], allowsMultipleSelection: true) { docs in
                // Do something with the resulting document URLs here
                print(docs)
            } dismiss: {
                presentDocumentPicker = false
            }
        }
    }
}
