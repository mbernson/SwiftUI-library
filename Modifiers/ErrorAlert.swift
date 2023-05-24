//
//  ErrorAlert.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 24/05/2023.
//

import SwiftUI

private struct ErrorAlert<E: LocalizedError>: ViewModifier {
    @Binding var error: E?
    let buttonTitle: LocalizedStringKey

    func body(content: Content) -> some View {
        content.alert(isPresented: .constant(error != nil), error: error) {
            Button(buttonTitle, action: dismiss)
        }
    }

    func dismiss() {
        error = nil
    }
}

extension View {
    /// Presents an alert when a localized error is present.
    func errorAlert<E: LocalizedError>(error: Binding<E?>, buttonTitle: LocalizedStringKey = "Ok") -> some View {
        modifier(ErrorAlert(error: error, buttonTitle: buttonTitle))
    }
}
