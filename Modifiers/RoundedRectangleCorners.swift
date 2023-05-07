//
//  RoundedRectangleCorners.swift
//
//  Created by Mathijs on 24/04/2021.
//

import SwiftUI
import UIKit

private struct RoundedRectangleCorners: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    /// Applies clipping to this view using corner radius, but only for the specified corners.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedRectangleCorners(radius: radius, corners: corners))
    }
}
