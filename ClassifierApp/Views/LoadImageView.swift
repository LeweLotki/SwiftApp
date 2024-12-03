import SwiftUI
import PhotosUI

struct LoadImageView: View {
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @ObservedObject var recognizer: ImageRecognizer
    @Binding var recognitionResults: [RecognitionResult]

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
                    .padding()
            }

            if case .error(let message) = recognizer.recognitionState {
                Text(message)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Run Recognition") {
                print("Run Recognition Button Pressed")
                if let currentImage = image {
                    Task {
                        recognizer.classifyImage(currentImage)
                        print("Recognition started for the image.")
                    }
                } else {
                    print("No image available to recognize.")
                }
            }
            .disabled(recognizer.recognitionState != .imageLoaded)
        }
        .padding()
        .onChange(of: selectedImageItem) { newItem in
            print("Image selection changed")
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    image = uiImage
                    recognizer.recognitionState = .imageLoaded
                    print("Image successfully loaded")
                } else {
                    print("Failed to load image")
                }
            }
        }
        .onChange(of: recognizer.results) { newResults in
            print("Recognition results updated")
            recognitionResults = newResults
        }
    }
}
