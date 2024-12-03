import CoreML
import Vision
import SwiftUI

class ImageRecognizer: ObservableObject {
    @Published var recognitionState: RecognitionState = .idle
    @Published var results: [RecognitionResult] = []

    private var model: VNCoreMLModel

    init?(modelName: String) {
        guard let compiledModelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc"),
              let mlModel = try? MLModel(contentsOf: compiledModelURL),
              let visionModel = try? VNCoreMLModel(for: mlModel) else {
            return nil
        }
        self.model = visionModel
    }

    func classifyImage(_ image: UIImage?) {
        guard let image = image else {
            recognitionState = .error("No image available.")
            return
        }

        recognitionState = .processing
        results = []

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.recognitionState = .error("Prediction error: \(error.localizedDescription)")
                }
                return
            }

            if let predictions = request.results as? [VNClassificationObservation] {
                DispatchQueue.main.async {
                    self?.results = predictions.map { RecognitionResult(label: $0.identifier, confidence: Double($0.confidence)) }
                    self?.recognitionState = .completed
                }
            } else {
                DispatchQueue.main.async {
                    self?.recognitionState = .error("No predictions found.")
                }
            }
        }

        #if targetEnvironment(simulator)
        request.usesCPUOnly = true
        #endif

        // Convert UIImage to CGImage
        guard let cgImage = image.cgImage else {
            recognitionState = .error("Invalid image format.")
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.recognitionState = .error("Image processing error: \(error.localizedDescription)")
                }
            }
        }
    }

}

enum RecognitionState: Equatable {
    case idle
    case imageLoaded
    case processing
    case completed
    case error(String)

    static func == (lhs: RecognitionState, rhs: RecognitionState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.imageLoaded, .imageLoaded),
             (.processing, .processing),
             (.completed, .completed):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

import Foundation

struct RecognitionResult: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let confidence: Double

    static func == (lhs: RecognitionResult, rhs: RecognitionResult) -> Bool {
        return lhs.label == rhs.label && lhs.confidence == rhs.confidence
    }
}

