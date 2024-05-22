//
//  ScreenBrightness.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 04/07/2023.
//

import SwiftUI

private struct ScreenBrightness: ViewModifier {
    let screen: UIScreen
    let duration: TimeInterval
    let ticksPerSecond: Double
    let maxBrightness: CGFloat = 1.0

    @State private var initialBrightness: CGFloat = UIScreen.main.brightness

    func body(content: Content) -> some View {
        content
            .onAppear {
                if initialBrightness < maxBrightness {
                    initialBrightness = UIScreen.main.brightness
                    screen.setBrightness(to: maxBrightness, duration: duration, ticksPerSecond: ticksPerSecond)
                }
            }
            .onDisappear {
                if initialBrightness < maxBrightness {
                    screen.setBrightness(to: initialBrightness, duration: duration, ticksPerSecond: ticksPerSecond)
                }
            }
    }
}

extension View {
    /// Increases the screen brightness when the view appears and restores it when the view disappears.
    func increasedScreenBrightness(
        duration: TimeInterval = 0.3,
        ticksPerSecond: Int = UIScreen.main.maximumFramesPerSecond
    ) -> some View {
        modifier(ScreenBrightness(screen: .main, duration: duration, ticksPerSecond: Double(ticksPerSecond)))
    }
}

private extension UIScreen {
    func setBrightness(to value: CGFloat, duration: TimeInterval = 0.3, ticksPerSecond: Double = 120) {
        let startingBrightness = UIScreen.main.brightness
        let delta = value - startingBrightness
        let totalTicks = Int(ticksPerSecond * duration)
        let changePerTick = delta / CGFloat(totalTicks)
        let delayBetweenTicks = 1 / ticksPerSecond

        let time = DispatchTime.now()

        for tick in 1...totalTicks {
            DispatchQueue.main.asyncAfter(deadline: time + delayBetweenTicks * Double(tick)) {
                UIScreen.main.brightness = max(min(startingBrightness + (changePerTick * CGFloat(tick)), 1), 0)
            }
        }
    }
}
