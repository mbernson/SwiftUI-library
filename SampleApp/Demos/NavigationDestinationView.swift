//
//  NavigationDestinationView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

private struct Person: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

@available(iOS 16.0, *)
struct NavigationDestinationView: View {
    private let people: [Person] = [
        Person(id: 1, name: "Alice Smith"),
        Person(id: 2, name: "Bob Johnson"),
        Person(id: 3, name: "Charlie Davis"),
        Person(id: 4, name: "Diana Evans"),
        Person(id: 5, name: "Edward Wilson"),
        Person(id: 6, name: "Fiona Brown"),
        Person(id: 7, name: "George Clark"),
        Person(id: 8, name: "Hannah Scott"),
        Person(id: 9, name: "Ian Moore"),
        Person(id: 10, name: "Julia Taylor"),
    ]
    @State private var selectedPerson: Person?

    var body: some View {
        NavigationStack {
            List {
                Section("People") {
                    ForEach(people) { person in
                        Button(person.name) {
                            selectedPerson = person
                        }
                    }
                }
            }
            .navigationTitle("People")
            .navigationDestination(item: $selectedPerson) { person in
                PersonView(person: person)
            }
        }
    }
}

private struct PersonView: View {
    let person: Person

    var body: some View {
        Text(person.name)
            .navigationTitle(person.name)
    }
}

@available(iOS 16.0, *)
private struct NavigationDestinationView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NavigationDestinationView()
        }
    }
}
