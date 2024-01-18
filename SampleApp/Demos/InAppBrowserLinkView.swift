//
//  InAppBrowserLinkView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 18/01/2024.
//

import SwiftUI

struct InAppBrowserLinkView: View {
    var body: some View {
        InAppBrowserLink("Q42", url: URL(string: "https://q42.com/")!)
    }
}

#Preview {
    InAppBrowserLinkView()
}
