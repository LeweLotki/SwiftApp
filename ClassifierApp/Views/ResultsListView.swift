import SwiftUI

struct ResultsListView: View {
    let results: [RecognitionResult]

    var body: some View {
        NavigationStack {
            if results.isEmpty {
                Text("No results available")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    Section(header: Text("High Confidence")) {
                        ForEach(results.filter { $0.confidence >= 0.5 }) { result in
                            NavigationLink(destination: DefinitionView(objectName: result.label)) {
                                ResultsRowView(objectName: result.label, confidence: result.confidence)
                            }
                        }
                    }

                    Section(header: Text("Moderate Confidence")) {
                        ForEach(results.filter { $0.confidence < 0.5 }) { result in
                            NavigationLink(destination: DefinitionView(objectName: result.label)) {
                                ResultsRowView(objectName: result.label, confidence: result.confidence)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Detection Results")
            }
        }
    }
}

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsListView(results: [
            RecognitionResult(label: "Cat", confidence: 0.95),
            RecognitionResult(label: "Dog", confidence: 0.85),
            RecognitionResult(label: "Car", confidence: 0.78),
            RecognitionResult(label: "Tree", confidence: 0.90)
        ])
    }
}
