import SwiftUI
import PhotosUI

struct LoadImageView: View {
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @StateObject private var recognizer = ImageRecognizer(modelName: "MyImageClassifier")!

    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedImageItem, matching: .images) {
                Text("Pick an Image")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.secondary)
            }

            if recognizer.recognitionState == .processing {
                ProgressView("Processing...")
            }

            if recognizer.recognitionState == .completed {
                List(recognizer.results) { result in
                    VStack(alignment: .leading) {
                        Text(result.label)
                            .font(.headline)
                        Text(String(format: "%.2f%%", result.confidence * 100))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            if case .error(let message) = recognizer.recognitionState {
                Text(message)
                    .foregroundColor(.red)
            }

            Button("Run Recognition") {
                Task {
                    recognizer.classifyImage(image)
                }
            }
            .disabled(recognizer.recognitionState != .imageLoaded)
        }
        .padding()
        .onChange(of: selectedImageItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    image = uiImage
                    recognizer.recognitionState = .imageLoaded
                }
            }
        }
    }
}
