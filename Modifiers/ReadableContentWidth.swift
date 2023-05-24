//
//  ReadableContentWidth.swift
//
//  Created by Mathijs on 18/05/2021.
//

import SwiftUI

private struct ReadableContentWidth: ViewModifier {
    private static let measureViewController = UIViewController()

    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: readableWidth(for: orientation))
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
    }

    private func readableWidth(for orientation: UIDeviceOrientation) -> CGFloat {
        let measureViewController = Self.measureViewController
        measureViewController.view.frame = UIScreen.main.bounds
        let readableContentSize = measureViewController.view.readableContentGuide.layoutFrame.size
        return readableContentSize.width
    }
}

extension View {
    /// Restricts the maximum width of the view to the Apple-defined readable content width.
    func readableContentWidth() -> some View {
        modifier(ReadableContentWidth())
    }
}
