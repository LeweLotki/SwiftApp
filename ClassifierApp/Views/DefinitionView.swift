import SwiftUI

struct DefinitionView: View {
    let objectName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(objectName)
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text("This is a placeholder definition for the detected object '\(objectName)'. Update this text to provide meaningful information about the object.")
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
