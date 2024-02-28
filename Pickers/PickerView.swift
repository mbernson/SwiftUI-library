//
//  PickerView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PickerView<SelectionValue: Hashable, Label: View>: View {
    @Binding var selection: SelectionValue?
    let isNullable: Bool
    let values: [SelectionValue]
//    @ViewBuilder let label: (SelectionValue) -> Label
    @Environment(\.pickerViewStyle) var style

    /// Creates a new picker view with a mandatory value.
    init(
        selection: Binding<SelectionValue>,
        values: [SelectionValue]
        //@ViewBuilder label: @escaping (SelectionValue) -> Label
    ) {
        self._selection = Binding(get: {
            selection.wrappedValue
        }, set: {
            selection.wrappedValue = $0!
        })
        self.isNullable = false
        self.values = values
//        self.label = label
    }

    /// Creates a new picker view with an optional value.
    /// The user can deselect the value.
    init(
        selection: Binding<SelectionValue?>,
        values: [SelectionValue]
//        @ViewBuilder label: @escaping (SelectionValue) -> Label
    ) {
        self._selection = selection
        self.isNullable = true
        self.values = values
//        self.label = label
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(values, id: \.self) { value in
                let configuration = PickerViewStyleConfiguration(label: Text(String(describing: value)), isSelected: value == selection)
                Button {
                    if isNullable && value == selection {
                        selection = nil
                    } else {
                        selection = value
                    }
                } label: {
                    style.makeBody(configuration: configuration)
                }
            }
        }
    }
}

protocol PickerViewStyle {
    associatedtype Body : View

    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    typealias Configuration = PickerViewStyleConfiguration
}

struct PickerViewStyleConfiguration {
    typealias Label = AnyView

    let label: Label
    let isSelected: Bool
}

struct DefaultPickerViewStyle: PickerViewStyle {
    @ScaledMetric var iconSize: CGFloat = 24

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(.white)
                .overlay(configuration.isSelected ? Circle().fill(Color.blue).padding(4) : nil)
                .frame(width: iconSize, height: iconSize)

            configuration.label
                .padding(.trailing, iconSize)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(minHeight: 54)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

private struct PickerViewStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue: any PickerViewStyle = DefaultPickerViewStyle()
}

private extension EnvironmentValues {
    var pickerViewStyle: any PickerViewStyle {
        get { self[PickerViewStyleEnvironmentKey.self] }
        set { self[PickerViewStyleEnvironmentKey.self] = newValue }
    }
}

extension View {
    func pickerViewStyle<S: PickerViewStyle>(_ style: S) -> some View {
        environment(\.pickerViewStyle, style)
    }
}

#Preview {
    PickerView(selection: .constant("Hello"), values: ["Hello", "World"]) { item in
        Text(item)
    }
}
