//
//  GridStack.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 18/01/2024.
//

import SwiftUI

/// A container view that arranges its child views centered in a grid that grows vertically.
struct GridStack<Data, Content: View>: View where Data : RandomAccessCollection {
    let data: Data
    let content: (Data.Element) -> Content
    let rows: Int
    let columns: Int
    let horizontalSpacing: CGFloat?
    let verticalSpacing: CGFloat?

    init(
        _ data: Data,
        columns: Int,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.columns = columns
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.rows = Int(ceil(Double(data.count) / Double(columns)))
    }

    var body: some View {
        GeometryReader { proxy in
            let totalHorizontalSpacing: CGFloat = (horizontalSpacing ?? 0) * CGFloat((columns - 1))
            let rowWidth: CGFloat = proxy.size.width - totalHorizontalSpacing
            let columnWidth: CGFloat = rowWidth / CGFloat(columns)
            let totalVerticalSpacing: CGFloat = (verticalSpacing ?? 0) * CGFloat((rows - 1))
            let rowHeight: CGFloat = (proxy.size.height - totalVerticalSpacing) / CGFloat(rows)
            LazyVStack(spacing: verticalSpacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: horizontalSpacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            let index = data.index(data.startIndex, offsetBy: (row * columns) + column)
                            if data.indices.contains(index) {
                                let item = data[index]
                                content(item)
                                    .frame(width: columnWidth)
                            }
                        }
                    }
                    .frame(maxHeight: rowHeight)
                }
            }
        }
    }
}

#Preview {
    struct Person {
        let name: String
        let color: Color
    }
    let people = [
        Person(name: "Alice", color: Color(red: 0.894, green: 0.012, blue: 0.012)),
        Person(name: "Bob", color: Color(red: 1.000, green: 0.549, blue: 0.000)),
        Person(name: "Carol", color: Color(red: 1.000, green: 0.929, blue: 0.000)),
        Person(name: "David", color: Color(red: 0.000, green: 0.502, blue: 0.149)),
        Person(name: "Erin", color: Color(red: 0.000, green: 0.302, blue: 1.000)),
        Person(name: "Faythe", color: Color(red: 0.459, green: 0.027, blue: 0.529)),
        Person(name: "Grace", color: Color(red: 1.000, green: 0.686, blue: 0.784)),
        Person(name: "Heidi", color: Color(red: 0.455, green: 0.843, blue: 0.933)),
        Person(name: "Ivan", color: Color(red: 0.380, green: 0.224, blue: 0.082)),
        Person(name: "Judy", color: Color(red: 0.000, green: 0.000, blue: 0.000)),
    ]
    return GridStack(people, columns: 3, horizontalSpacing: 12, verticalSpacing: 8) { person in
        VStack {
            person.color
                .aspectRatio(1, contentMode: .fit)
                .clipShape(Circle())

            Text(person.name)
                .font(.caption)
        }
    }
}
