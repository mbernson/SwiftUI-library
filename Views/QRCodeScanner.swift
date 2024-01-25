//
//  QRCodeScanner.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 18/01/2024.
//

import SwiftUI
import AVFoundation
import UIKit

/// A view that displays a camera feed, that scans for a QR code.
struct QRCodeScanner: UIViewControllerRepresentable {
    let mode: Mode
    let action: (String) -> Void

    init(mode: Mode = .once, action: @escaping (String) -> Void) {
        self.mode = mode
        self.action = action
    }

    enum Mode {
        /// Scan until one code is found, then stop giving new results.
        case once
        /// Scan continuously, returning every code that is succesfully scanned.
        case continuous
    }

    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let controller = QRCodeScannerViewController(codeTypes: [.qr])
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QRCodeScannerViewController, context: Context) {
        controller.delegate = context.coordinator
        context.coordinator.mode = mode
        context.coordinator.resultHandler = action
    }

    func makeCoordinator() -> QRCodeScannerDelegate {
        QRCodeScannerDelegate(mode: mode)
    }
}

class QRCodeScannerDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var resultHandler: ((String) -> Void)?
    var scannedCodes = Set<String>()
    var mode: QRCodeScanner.Mode

    init(mode: QRCodeScanner.Mode) {
        self.mode = mode
        super.init()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = readableObject.stringValue,
              !scannedCodes.contains(code) else { return }
        
        scannedCodes.insert(code)
        if mode == .once && !scannedCodes.isEmpty {
            return
        }
        resultHandler?(code)
    }
}

// Based on: https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
class QRCodeScannerViewController: UIViewController {
    let codeTypes: [AVMetadataObject.ObjectType]
    private var captureSession: AVCaptureSession?
    weak var delegate: QRCodeScannerDelegate?
    private let backgroundQueue: DispatchQueue

    override var prefersStatusBarHidden: Bool { true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    init(codeTypes: [AVMetadataObject.ObjectType]) {
        self.codeTypes = codeTypes
        self.backgroundQueue = DispatchQueue(label: "CodeScanner", qos: .userInitiated)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }

        let captureSession = AVCaptureSession()

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = codeTypes
        } else {
            failed()
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        self.captureSession = captureSession
        startCapture()
    }

    func failed() {
        let alert = UIAlertController(
            title: NSLocalizedString("Scanning not supported", comment: "QR Code Scanner"),
            message: NSLocalizedString("Your device does not support scanning a code. Please use a device with a camera.", comment: "QR Code Scanner"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "QR Code Scanner"), style: .default))
        present(alert, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startCapture()
    }

    func startCapture() {
        if let captureSession, !captureSession.isRunning {
            backgroundQueue.async {
                captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopCapture()
    }

    func stopCapture() {
        if let captureSession, captureSession.isRunning {
            backgroundQueue.async {
                captureSession.stopRunning()
            }
        }
    }
}
