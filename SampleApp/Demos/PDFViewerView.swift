//
//  PDFViewerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PDFViewerView: View {
    var body: some View {
        PDFViewer(url: Bundle.main.url(forResource: "sample", withExtension: "pdf"))
            .ignoresSafeArea()
            .navigationTitle("PDF viewer")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PDFViewerView()
}
