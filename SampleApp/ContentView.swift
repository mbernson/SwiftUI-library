//
//  ContentView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Pickers") {
                    NavigationLink("Document picker", destination: DocumentPickerView())
                    NavigationLink("Photo picker", destination: PhotoPickerView())
                }

                Section("System components") {
                    NavigationLink("Safari view", destination: SafariSheetView())
                    NavigationLink("Share sheet", destination: ShareSheetView())
                }

                Section("Modifiers") {
                    NavigationLink("Readable content width", destination: ReadableContentWidthView())
                    NavigationLink("Rounded rectangle corners", destination: RoundedRectangleCornersView())
                }
            }
            .navigationTitle("SwiftUI library")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
