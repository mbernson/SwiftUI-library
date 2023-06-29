//
//  CustomTextView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 17/06/2023.
//

import SwiftUI
import UIKit

struct CustomTextView: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = "Hello world!"
        textView.backgroundColor = .systemRed
        textView.textColor = .white
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        //
    }
}

struct CustomTextView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextView()
            .background(.red)
    }
}
