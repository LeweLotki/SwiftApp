import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Load Image", systemImage: "photo") {
                LoadImageView()
            }

            Tab("Results", systemImage: "list.bullet") {
                ResultsListView()
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

