import AVFoundation
import Combine
import Vision

final class FaceTrackingManager: NSObject, ObservableObject {
    @Published private(set) var normalizedFaceOffset: CGPoint = .zero

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "face-tracking-session")
    private let visionQueue = DispatchQueue(label: "face-tracking-vision")
    private var videoOutput: AVCaptureVideoDataOutput?

    func start() {
        sessionQueue.async {
            guard !self.session.isRunning else { return }
            self.configureSessionIfNeeded()
            self.session.startRunning()
        }
    }

    func stop() {
        sessionQueue.async {
            guard self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    private func configureSessionIfNeeded() {
        guard session.inputs.isEmpty else { return }
        session.beginConfiguration()
        session.sessionPreset = .vga640x480

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: visionQueue)
        output.alwaysDiscardsLateVideoFrames = true

        if session.canAddOutput(output) {
            session.addOutput(output)
            videoOutput = output
        }

        session.commitConfiguration()
    }
}

extension FaceTrackingManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        let request = VNDetectFaceRectanglesRequest { [weak self] request, _ in
            guard let observation = request.results?.first as? VNFaceObservation else {
                DispatchQueue.main.async {
                    self?.normalizedFaceOffset = .zero
                }
                return
            }

            let boundingBox = observation.boundingBox
            let centerX = boundingBox.midX - 0.5
            let centerY = boundingBox.midY - 0.5
            let offset = CGPoint(x: centerX * 2, y: centerY * 2)

            DispatchQueue.main.async {
                self?.normalizedFaceOffset = offset
            }
        }

        try? handler.perform([request])
    }
}
