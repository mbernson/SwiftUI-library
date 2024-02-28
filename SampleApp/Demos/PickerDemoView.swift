//
//  PickerDemoView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PickerDemoView: View {
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }

        var description: String {
            rawValue.capitalized
        }
    }

    let flavors: [Flavor] = Flavor.allCases
    @State var selectedFlavor: Flavor = .chocolate
    @State var optionalFlavor: Flavor? = nil

    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading) {
                Text("Picker with non-optional value")
                    .font(.headline)
                PickerView(selection: $selectedFlavor, values: flavors) { flavor in
                    TextPickerItem(item: flavor.description, isSelected: flavor == selectedFlavor)
                }
            }

            VStack(alignment: .leading) {
                Text("Picker with optional value")
                    .font(.headline)
                PickerView(selection: $optionalFlavor, values: flavors) { flavor in
                    TextPickerItem(item: flavor.description, isSelected: flavor == optionalFlavor)
                }
            }
        }
        .padding()
    }
}

private struct TextPickerItem: View {
    let item: String
    let isSelected: Bool
    @ScaledMetric var iconSize: CGFloat = 24

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.white)
                .overlay(isSelected ? Circle().fill(Color.accentColor).padding(4) : nil)
                .frame(width: iconSize, height: iconSize)

            Text(item)
                .padding(.trailing, iconSize)
            Spacer()
        }
        .padding()
        .frame(minHeight: 44)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    PickerDemoView()
}
