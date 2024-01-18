//
//  GridStackView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 18/01/2024.
//

import SwiftUI

struct GridStackView: View {
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

    var body: some View {
        GridStack(people, columns: 3, horizontalSpacing: 12, verticalSpacing: 8) { person in
            VStack {
                person.color
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())

                Text(person.name)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    GridStackView()
}
