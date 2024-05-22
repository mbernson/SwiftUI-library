//
//  PrintButton.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI
import UIKit

struct PrintButton<Label: View>: View {
    private let printItem: PrintItem?
    @StateObject private var model = PrintModel()
    @State private var error: PrintError?
    @ViewBuilder let label: () -> Label

    var isEnabled: Bool {
        UIPrintInteractionController.isPrintingAvailable && printItem != nil
    }

    init(url: URL?, @ViewBuilder label: @escaping () -> Label) {
        self.printItem = url.map { .url($0) }
        self.label = label
    }

    init(data: Data?, @ViewBuilder label: @escaping () -> Label) {
        self.printItem = data.map { .data($0) }
        self.label = label
    }

    init(image: UIImage?, @ViewBuilder label: @escaping () -> Label) {
        self.printItem = image.map { .image($0) }
        self.label = label
    }

    var body: some View {
        Button {
            guard let item = printItem else { return }
            guard model.canPrint(item: item) else {
                self.error = PrintError(message: String(localized: "Unable to print the given item."))
                return
            }
            model.printItem(item: item)
        } label: {
            label()
        }
        .disabled(!isEnabled)
        .alert(isPresented: .constant(error != nil), error: error) {
            Button("Ok") {
                error = nil
            }
        }
    }
}

private enum PrintItem {
    case url(URL)
    case data(Data)
    case image(UIImage)
}

private struct PrintError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

private class PrintModel: ObservableObject {
    let printController: UIPrintInteractionController

    init() {
        printController = UIPrintInteractionController.shared
    }

    func canPrint(item: PrintItem) -> Bool {
        switch item {
        case .data(let data):
            return UIPrintInteractionController.canPrint(data)
        case .url(let url):
            return UIPrintInteractionController.canPrint(url)
        case .image:
            return true
        }
    }

    func printItem(item: PrintItem) {
        switch item {
        case .data(let data):
            printController.printingItem = data as NSData
        case .url(let url):
            printController.printingItem = url as NSURL
        case .image(let image):
            printController.printingItem = image
        }

        printController.present(animated: true)
    }
}

#Preview {
    PrintButton(image: UIImage(systemName: "globe")) {
        Label("Print", systemImage: "printer")
    }
}
