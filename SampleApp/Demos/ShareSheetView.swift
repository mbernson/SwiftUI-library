//
//  ShareSheetView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct ShareSheetView: View {
    @State var presentShareSheet = false

    var body: some View {
        Button("Present share sheet") {
            presentShareSheet.toggle()
        }
        .sheet(isPresented: $presentShareSheet) {
            ShareSheet(activityItems: [URL(string: "https://q42.com")!]) { success in
                print("Share finished successfully: \(success)")
                if success {
                    presentShareSheet = false
                }
            }
        }
    }
}
