import SwiftUI
import PhotosUI

struct LoadImageView: View {
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var image: Image? = nil
    @State private var processingState: ImageProcessingState = .idle
    @State private var progress: Double = 0.0

    enum ImageProcessingState: String {
        case idle = "Select an image to start"
        case loading = "Loading image..."
        case ready = "Image ready for processing"
        case processing = "Processing image..."
        case completed = "Processing completed!"
        case failed = "Failed to process image"
    }

    var body: some View {
        VStack(spacing: 20) {
            // Image Picker Section
            PhotosPicker(selection: $selectedImageItem, matching: .images) {
                Text("Pick an Image")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .onChange(of: selectedImageItem) { newItem in
                Task {
                    processingState = .loading
                    if let loadedImage = try? await newItem?.loadTransferable(type: Image.self) {
                        image = loadedImage
                        processingState = .ready
                    } else {
                        processingState = .failed
                    }
                }
            }

            // Display Selected Image or Placeholder
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(Text("No image selected").foregroundColor(.secondary))
            }

            // Status Display
            Text(processingState.rawValue)
                .font(.headline)
                .foregroundColor(processingState == .failed ? .red : .primary)

            // Processing Button and Progress Bar
            VStack(spacing: 10) {
                if processingState == .processing {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.horizontal)
                }

                Button(action: startProcessing) {
                    Text("Start Processing")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(processingState == .ready ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(processingState != .ready)
            }
        }
        .padding()
    }

    // Mock processing function
    private func startProcessing() {
        processingState = .processing
        progress = 0.0
        Task {
            for i in 1...10 {
                try? await Task.sleep(nanoseconds: 300_000_000) // Simulate processing delay
                progress = Double(i) / 10.0
            }
            processingState = .completed
        }
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView()
    }
}
