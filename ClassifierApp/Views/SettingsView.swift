import SwiftUI

struct SettingsView: View {
    @State private var selectedGender: String = "Other"
    
    let genders = ["Woman", "Man", "Other"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Settings")) {
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
