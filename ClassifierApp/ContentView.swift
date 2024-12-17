import SwiftUI

struct ContentView: View {
    @State private var recognitionResults: [RecognitionResult] = []
    @StateObject private var recognizer = ImageRecognizer(modelName: "MyImageClassifier")!

    var body: some View {
        TabView {
            LoadImageView(recognizer: recognizer, recognitionResults: $recognitionResults)
                .tabItem {
                    Label("Load Image", systemImage: "photo")
                }

            ResultsListView(results: recognitionResults)
                .tabItem {
                    Label("Results", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
