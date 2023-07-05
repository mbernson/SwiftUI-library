//
//  PhotoPickerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct PhotoPickerView: View {
    @State var presentPhotoPicker = false

    var body: some View {
        Button("Present photo picker") {
            presentPhotoPicker.toggle()
        }
        .sheet(isPresented: $presentPhotoPicker) {
            PhotoPicker { items in
                // Do something with the resulting NSItemProviders here
                print(items)
                presentPhotoPicker = false
            } dismiss: {
                presentPhotoPicker = false
            }
        }
    }
}
