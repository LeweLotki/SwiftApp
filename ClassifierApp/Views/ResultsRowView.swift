import SwiftUI

struct ResultsRowView: View {
    let objectName: String
    let confidence: Double

    init(objectName: String, confidence: Double) {
        self.objectName = objectName
        self.confidence = confidence
    }

    var body: some View {
        NavigationLink(destination: DefinitionView(objectName: objectName)) {
            HStack {
                Text(objectName)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(String(format: "%.2f%%", confidence * 100))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 4)
        }
    }
}

struct ResultsRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsRowView(objectName: "Dog", confidence: 0.85)
            .previewLayout(.sizeThatFits)
    }
}
