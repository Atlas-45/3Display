import AVFoundation
import Vision
import Combine
import AppKit

/// 顔追跡を行い、顔の位置を公開するマネージャー
@MainActor
public final class FaceTrackingManager: NSObject, ObservableObject {
    /// 正規化された顔の位置 (-1 to 1)
    @Published public var facePosition: CGPoint = .zero
    /// 顔が検出されているか
    @Published public var isFaceDetected: Bool = false
    /// トラッキングが有効か
    @Published public var isTracking: Bool = false
    /// エラーメッセージ
    @Published public var errorMessage: String?
    
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let videoQueue = DispatchQueue(label: "com.threedisplay.facetracking", qos: .userInteractive)
    
    private var sequenceHandler = VNSequenceRequestHandler()
    private var lastFacePosition: CGPoint = .zero
    private let smoothingFactor: CGFloat = 0.3 // スムージング係数
    
    private var processingDelegate: FaceProcessingDelegate?
    
    public override init() {
        super.init()
        processingDelegate = FaceProcessingDelegate { [weak self] position, detected in
            Task { @MainActor [weak self] in
                self?.facePosition = position
                self?.isFaceDetected = detected
            }
        }
    }
    
    /// トラッキングを開始
    public func startTracking() {
        guard !isTracking else { return }
        
        // カメラ権限を確認
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor [weak self] in
                    if granted {
                        self?.setupCaptureSession()
                    } else {
                        self?.errorMessage = "Camera access denied"
                    }
                }
            }
        case .denied, .restricted:
            self.errorMessage = "Camera access denied. Please enable in System Preferences."
        @unknown default:
            break
        }
    }
    
    /// トラッキングを停止
    public func stopTracking() {
        videoQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
        }
        captureSession = nil
        videoOutput = nil
        isTracking = false
        isFaceDetected = false
        facePosition = .zero
    }
    
    private func setupCaptureSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .low // 低解像度で高速処理
        
        // カメラデバイスを取得
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
              ?? AVCaptureDevice.default(for: .video) else {
            self.errorMessage = "No camera found"
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(processingDelegate, queue: videoQueue)
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            self.videoOutput = output
            self.captureSession = session
            
            // バックグラウンドで開始
            videoQueue.async { [weak self] in
                session.startRunning()
                Task { @MainActor [weak self] in
                    self?.isTracking = true
                    self?.errorMessage = nil
                }
            }
            
        } catch {
            self.errorMessage = "Failed to setup camera: \(error.localizedDescription)"
        }
    }
}

/// 顔検出処理を行うデリゲート（非MainActor）
private final class FaceProcessingDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    private var sequenceHandler = VNSequenceRequestHandler()
    private var lastFacePosition: CGPoint = .zero
    private let smoothingFactor: CGFloat = 0.3
    
    private let onFaceUpdate: @Sendable (CGPoint, Bool) -> Void
    
    init(onFaceUpdate: @escaping @Sendable (CGPoint, Bool) -> Void) {
        self.onFaceUpdate = onFaceUpdate
        super.init()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        detectFace(in: pixelBuffer)
    }
    
    private func detectFace(in pixelBuffer: CVPixelBuffer) {
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            
            guard error == nil,
                  let results = request.results as? [VNFaceObservation],
                  let face = results.first else {
                self.onFaceUpdate(.zero, false)
                return
            }
            
            // 顔の中心位置を計算（0-1の範囲）
            let faceCenterX = face.boundingBox.midX
            let faceCenterY = face.boundingBox.midY
            
            // -1 to 1 の範囲に正規化（中央が0）
            // X軸は反転（カメラは鏡像）
            let normalizedX = -((faceCenterX - 0.5) * 2.0)
            let normalizedY = (faceCenterY - 0.5) * 2.0
            
            // スムージング適用
            let smoothedX = self.lastFacePosition.x + (normalizedX - self.lastFacePosition.x) * self.smoothingFactor
            let smoothedY = self.lastFacePosition.y + (normalizedY - self.lastFacePosition.y) * self.smoothingFactor
            
            self.lastFacePosition = CGPoint(x: smoothedX, y: smoothedY)
            self.onFaceUpdate(self.lastFacePosition, true)
        }
        
        request.preferBackgroundProcessing = false
        
        do {
            try sequenceHandler.perform([request], on: pixelBuffer, orientation: .up)
        } catch {
            // フレームドロップ
        }
    }
}
