//
//  PhotoPickerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct PhotoPickerView: View {
    @State var isPresentingPhotoPicker = false
    @State var selectedImage: UIImage?

    var body: some View {
        VStack {
            Button("Present photo picker") {
                isPresentingPhotoPicker.toggle()
            }

            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .sheet(isPresented: $isPresentingPhotoPicker) {
            PhotoPicker(filter: .images, selectionLimit: 1, preferredAssetRepresentationMode: .compatible) { providers in
                isPresentingPhotoPicker = false
                guard providers.count == 1, let provider = providers.first else { return }
                _ = provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                    if let data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedImage = image
                        }
                    } else if let error {
                        print(error)
                    }
                }
            } dismiss: {
                isPresentingPhotoPicker = false
            }
        }
    }
}
