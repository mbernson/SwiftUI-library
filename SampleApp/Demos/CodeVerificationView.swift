//
//  CodeVerificationView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 15/02/2024.
//

import SwiftUI

struct CodeVerificationView: View {
    @State var code = ""

    var body: some View {
        CodeVerificationField(code: $code, maxDigits: 6) { code in
            print(code)
        }
        .padding()
    }
}
