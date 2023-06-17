//
//  ImageViewerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 14/06/2023.
//

import SwiftUI

struct ImageViewerView: View {
    var body: some View {
        ImageViewer(image: UIImage(named: "demoImage"))
            .ignoresSafeArea(edges: [.horizontal, .bottom])
            .navigationTitle("Image viewer")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageViewerView_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewerView()
    }
}
