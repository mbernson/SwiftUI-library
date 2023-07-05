//
//  CameraDemoView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 14/06/2023.
//

import SwiftUI

struct CameraDemoView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        CameraView(photoPicked: { photo in
            print(photo)
        }, dismiss: {
            print("User cancelled")
//            presentationMode.isPresented = false
        })
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct CameraDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CameraDemoView()
    }
}
