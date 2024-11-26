import SwiftUI

struct ResultsListView: View {
    let detectedObjects: [(String, Double)] = [
        ("Cat", 0.95),
        ("Dog", 0.85),
        ("Car", 0.78),
        ("Tree", 0.90)
    ]

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("High Confidence")) {
                    ForEach(detectedObjects.filter { $0.1 >= 0.9 }, id: \.0) { object in
                        ResultsRowView(objectName: object.0, confidence: object.1)
                    }
                }

                Section(header: Text("Moderate Confidence")) {
                    ForEach(detectedObjects.filter { $0.1 < 0.9 }, id: \.0) { object in
                        ResultsRowView(objectName: object.0, confidence: object.1)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Detection Results")
        }
    }
}

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsListView()
    }
}
