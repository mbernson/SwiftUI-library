//
//  ImageViewer.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 14/06/2023.
//

import SwiftUI
import UIKit

struct ImageViewer: UIViewControllerRepresentable {
    private let content: Content
    private let maximumZoomScale: CGFloat
    private let showsIndicators: Bool

    enum Content {
        case image(UIImage?)
        case url(URL?)
    }

    init(image: UIImage?, maximumZoomScale: CGFloat = 3.0, showsIndicators: Bool = true) {
        self.content = .image(image)
        self.maximumZoomScale = maximumZoomScale
        self.showsIndicators = showsIndicators
    }

    init(url: URL?, maximumZoomScale: CGFloat = 3.0, showsIndicators: Bool = true) {
        self.content = .url(url)
        self.maximumZoomScale = maximumZoomScale
        self.showsIndicators = showsIndicators
    }

    func makeUIViewController(context: Context) -> ImageViewerController {
        return ImageViewerController()
    }

    func updateUIViewController(_ viewController: ImageViewerController, context: Context) {
        switch content {
        case .image(let image):
            viewController.setImage(image)
        case .url(let url):
            viewController.setURL(url)
        }
        viewController.scrollView.maximumZoomScale = maximumZoomScale
        viewController.scrollView.showsVerticalScrollIndicator = showsIndicators
        viewController.scrollView.showsHorizontalScrollIndicator = showsIndicators
    }
}

class ImageViewerController: UIViewController, UIScrollViewDelegate {
    private let imageView = UIImageView()
    fileprivate let scrollView = UIScrollView()
    private var previousURL: URL?

    func setImage(_ image: UIImage?) {
        imageView.image = image
        resetZoom(animated: false)
    }

    func setURL(_ url: URL?) {
        guard let url else {
            imageView.image = nil
            return
        }
        guard url != previousURL else { return }
        previousURL = url
        Task {
            do {
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                self.imageView.image = UIImage(data: data)
            } catch {
                self.previousURL = nil
                self.showLoadingFailedAlert(for: url, error: error)
            }
        }
    }

    private func showLoadingFailedAlert(for url: URL, error: Error) {
        let title = NSLocalizedString("Afbeelding kon niet worden geladen", comment: "Image viewer")
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Probeer opnieuw", comment: "Image viewer"), style: .default) { _ in
            self.setURL(url)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Annuleren", comment: "Image viewer"), style: .cancel))
        present(alertController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = .scaleAspectFit

        scrollView.delegate = self
        scrollView.autoresizesSubviews = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Add double tap to zoom gesture
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleZoom))
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(shareImage))
        scrollView.addGestureRecognizer(longPressRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetZoom(animated: false)
    }

    @objc private func toggleZoom() {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
          scrollView.setZoomScale(scrollView.maximumZoomScale / 2, animated: true)
        } else {
          scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }

    func resetZoom(animated: Bool) {
      scrollView.setZoomScale(scrollView.minimumZoomScale, animated: animated)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @objc func shareImage(_ sender: UILongPressGestureRecognizer) {
        guard let image = imageView.image, sender.state == .began else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = imageView
        activityController.popoverPresentationController?.sourceRect = CGRect(
            origin: sender.location(in: imageView),
            size: CGSize(width: 44, height: 44)
        )
        present(activityController, animated: true)
    }
}

#Preview("Image viewer with image") {
    ImageViewer(image: UIImage(named: "demoImage"))
        .ignoresSafeArea()
}

#Preview("Image viewer with URL") {
    ImageViewer(url: URL(string: "https://placekitten.com/1024/1024"))
        .ignoresSafeArea()
}
