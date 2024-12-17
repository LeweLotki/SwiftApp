import SwiftUI
import Alamofire

struct DefinitionView: View {
    let objectName: String
    @State private var definition: String = "Loading..."
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(objectName)
                .font(.largeTitle)
                .bold()
                .padding(.top)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.red)
            } else {
                Text(definition)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Definition")
        .onAppear {
            fetchDefinition(for: objectName)
        }
    }

    // Fetch definition from the API
    private func fetchDefinition(for word: String) {
        let url = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word.lowercased())"
        AF.request(url).responseDecodable(of: [DictionaryEntry].self) { response in
            switch response.result {
            case .success(let entries):
                if let filteredDefinition = filterDefinition(from: entries) {
                    definition = filteredDefinition
                } else {
                    definition = "No suitable definition found for '\(word)'."
                }
            case .failure:
                errorMessage = "Failed to fetch definition. Please try again."
            }
        }
    }

    // Filter the API response for the first relevant definition
    private func filterDefinition(from entries: [DictionaryEntry]) -> String? {
        for entry in entries {
            for meaning in entry.meanings {
                // Prioritize "noun" as the part of speech
                if meaning.partOfSpeech == "noun",
                   let definition = meaning.definitions.first?.definition {
                    return definition
                }
            }
        }
        return entries.first?.meanings.first?.definitions.first?.definition
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(objectName: "tree")
    }
}

struct DictionaryEntry: Codable {
    let word: String
    let meanings: [Meaning]
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    let definition: String
}
