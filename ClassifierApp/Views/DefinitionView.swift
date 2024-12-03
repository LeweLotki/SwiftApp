import SwiftUI

struct DefinitionView: View {
    let objectName: String

    // Updated the access level of the definitions dictionary to `internal` (default) for broader access.
    static let definitions: [String: String] = [
        "Cat": "A small domesticated carnivorous mammal with soft fur, a short snout, and retractile claws. Widely kept as a pet or for catching mice.",
        "Dog": "A domesticated carnivorous mammal that typically has a long snout, an acute sense of smell, and a barking, howling, or whining voice. Often kept as a pet or for work such as hunting or herding.",
        "Tree": "A woody perennial plant, typically having a single stem or trunk growing to a considerable height and bearing lateral branches at some distance from the ground.",
        "Car": "A road vehicle, typically with four wheels, powered by an internal combustion engine or electric motor and able to carry a small number of people."
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(objectName)
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text(DefinitionView.definitions[objectName] ?? "No definition available for '\(objectName)'.")
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Definition")
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(objectName: "Cat")
    }
}
