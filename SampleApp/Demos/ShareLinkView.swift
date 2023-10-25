//
//  ShareLinkView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct ShareLinkView: View {
    var body: some View {
        LegacyShareLink("Share", item: URL(string: "https://q42.com")!) {
            print("Share completion")
        }
    }
}
