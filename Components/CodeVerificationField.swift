//
//  CodeVerificationField.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 25/01/2024.
//

import SwiftUI

/// A field specific to enter numeric verification codes, such as two-factor (SMS) codes.
struct CodeVerificationField: View {
    @Binding var code: String
    let maxDigits: Int
    let submitHandler: (String) -> Void
    let digitWidth: CGFloat = 56
    let digitHeight: CGFloat = 64

    var body: some View {
        ZStack {
            // Digit boxes for displaying the entered code
            HStack {
                ForEach(0..<maxDigits, id: \.self) { index in
                    let digit = code.digits.indices.contains(index) ? String(code.digits[index]) : String()
                    Text(digit)
                        .frame(
                            idealWidth: digitWidth, maxWidth: digitWidth,
                            idealHeight: digitHeight, maxHeight: digitHeight
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 8.0).stroke(.gray)
                        }
                }
            }
            .multilineTextAlignment(.center)
            .font(.title)
            .accessibilityHidden(true)

            // This hidden text field contains the actual code
            TextField("", text: $code, onCommit: submit)
                .textSelection(.disabled)
                .accentColor(.clear)
                .foregroundColor(.clear)
                .keyboardType(.numberPad)
                .onChange(of: code, perform: { _ in submit() })
                .accessibilityLabel("Verification code")
        }
    }

    private func submit() {
        if code.isEmpty {
            return
        } else if code.count == maxDigits {
            submitHandler(code)
        } else if code.count > maxDigits {
            code = String(code.prefix(maxDigits))
            submit()
        }
    }
}

private extension String {
    var digits: [Int] {
        self.compactMap { char in
            Int(String(char))
        }
    }
}

private struct CodeVerificationField_Preview: View {
    @State var code = "123"
    var body: some View {
        CodeVerificationField(code: $code, maxDigits: 6) { code in
            print(code)
        }
        .padding()
    }
}

#Preview {
    CodeVerificationField_Preview()
}
