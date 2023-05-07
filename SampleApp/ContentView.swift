//
//  ContentView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State var presentDocumentPicker = false
    @State var presentPhotoPicker = false
    @State var presentSafariView = false
    @State var presentShareSheet = false

    var body: some View {
        NavigationStack {
            List {
                Section("Pickers") {
                    Button("Document picker") {
                        presentDocumentPicker.toggle()
                    }
                    .sheet(isPresented: $presentDocumentPicker) {
                        DocumentPicker(contentTypes: [.image, .video], allowsMultipleSelection: true) { docs in
                            print(docs)
                        } dismiss: {
                            presentDocumentPicker = false
                        }
                    }
                    Button("Photo picker") {
                        presentPhotoPicker.toggle()
                    }
                    .sheet(isPresented: $presentPhotoPicker) {
                        PhotoPicker { items in
                            print(items)
                            presentPhotoPicker = false
                        } dismiss: {
                            presentPhotoPicker = false
                        }
                    }
                }

                Section("System components") {
                    Button("Safari view") {
                        presentSafariView.toggle()
                    }
                    .sheet(isPresented: $presentSafariView) {
                        SafariView(url: URL(string: "https://q42.com")!)
                    }

                    Button("Share sheet") {
                        presentShareSheet.toggle()
                    }
                    .sheet(isPresented: $presentShareSheet) {
                        ShareSheet(activityItems: [URL(string: "https://q42.com")!])
                    }
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
