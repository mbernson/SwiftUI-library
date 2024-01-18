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

    private enum Content {
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
    private let progressView = UIActivityIndicatorView(style: .medium)
    private var previousURL: URL?

    func setImage(_ image: UIImage?) {
        imageView.image = image
        progressView.stopAnimating()
        resetZoom(animated: false)
    }

    func setURL(_ url: URL?) {
        guard let url else {
            imageView.image = nil
            return
        }
        guard url != previousURL else { return }
        previousURL = url
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.progressView.stopAnimating()
                if let data {
                    self.imageView.image = UIImage(data: data)
                } else if let error {
                    self.previousURL = nil
                    self.showLoadingFailedAlert(for: url, error: error)
                }
            }
        }
        progressView.startAnimating()
        task.resume()
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

        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
