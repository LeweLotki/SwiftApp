import SwiftUI
import PhotosUI

struct LoadImageView: View {
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var image: Image? = nil

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
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .onChange(of: selectedImageItem) { newItem in
            Task {
                if let loadedImage = try? await newItem?.loadTransferable(type: Image.self) {
                    image = loadedImage
                }
            }
        }
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView()
    }
}

