//
//  ScreenBrightness.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 04/07/2023.
//

import SwiftUI

private struct ScreenBrightness: ViewModifier {
    let screen: UIScreen
    let initialBrightness: CGFloat
    let duration: TimeInterval
    let ticksPerSecond: Double

    func body(content: Content) -> some View {
        content
            .onAppear {
                screen.setBrightness(to: 1.0, duration: duration, ticksPerSecond: ticksPerSecond)
            }
            .onDisappear {
                screen.setBrightness(to: initialBrightness, duration: duration, ticksPerSecond: ticksPerSecond)
            }
    }
}

extension View {
    func increasedScreenBrightness(
        duration: TimeInterval = 0.3,
        ticksPerSecond: Int = UIScreen.main.maximumFramesPerSecond
    ) -> some View {
        modifier(ScreenBrightness(screen: .main, initialBrightness: UIScreen.main.brightness, duration: duration, ticksPerSecond: Double(ticksPerSecond)))
    }
}

extension UIScreen {
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
