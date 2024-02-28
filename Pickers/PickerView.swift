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
    @ViewBuilder let label: (SelectionValue) -> Label
    @StateObject private var model = PickerModel()

    /// Creates a new picker view that has a non-optionally selected value.
    init(
        selection: Binding<SelectionValue>,
        values: [SelectionValue],
        @ViewBuilder label: @escaping (SelectionValue) -> Label
    ) {
        self._selection = Binding {
            selection.wrappedValue
        } set: {
            selection.wrappedValue = $0!
        }
        self.isNullable = false
        self.values = values
        self.label = label
    }

    /// Creates a new picker view with an optionally selected value, so that the user can deselect the value.
    init(
        selection: Binding<SelectionValue?>,
        values: [SelectionValue],
        @ViewBuilder label: @escaping (SelectionValue) -> Label
    ) {
        self._selection = selection
        self.isNullable = true
        self.values = values
        self.label = label
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(values, id: \.self) { value in
                Button {
                    if isNullable && value == selection {
                        selection = nil
                    } else {
                        selection = value
                    }
                    model.selectionChanged()
                } label: {
                    label(value)
                }
            }
        }
    }
}

private class PickerModel: ObservableObject {
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    func selectionChanged() {
        feedbackGenerator.selectionChanged()
    }
}

#Preview {
    PickerView(selection: .constant("Hello"), values: ["Hello", "World"]) { item in
        Text(item)
    }
}
