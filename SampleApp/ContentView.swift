//
//  ContentView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("Document picker", destination: DocumentPickerView())
                    NavigationLink("Photo picker", destination: PhotoPickerView())
                } header: {
                    Text("Pickers")
                }

                Section {
                    NavigationLink("Image viewer", destination: ImageViewerView())
                    NavigationLink("Camera view", destination: CameraDemoView())
                } header: {
                    Text("Views")
                }

                Section {
                    NavigationLink("Safari sheet", destination: SafariSheetView())
                    NavigationLink("Share sheet", destination: ShareSheetView())
                } header: {
                    Text("Sheets")
                }

                Section {
                    NavigationLink("QR code view", destination: QRCodeView())
                } header: {
                    Text("Views")
                }

                Section {
                    NavigationLink("Readable content width", destination: ReadableContentWidthView())
                    NavigationLink("Rounded rectangle corners", destination: RoundedRectangleCornersView())
                    NavigationLink("Device shake", destination: DeviceShakeView())
                    NavigationLink("Screen brightness", destination: QRCodeView())
                } header: {
                    Text("Modifiers")
                }
            }
            .navigationTitle(Text("SwiftUI library"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
