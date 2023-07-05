//
//  ImageViewer.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 14/06/2023.
//

import SwiftUI
import UIKit

struct ImageViewer: UIViewControllerRepresentable {
    let image: UIImage?
    let maximumZoomScale: CGFloat
    let showsIndicators: Bool

    init(image: UIImage?, maximumZoomScale: CGFloat = 3.0, showsIndicators: Bool = true) {
        self.image = image
        self.maximumZoomScale = maximumZoomScale
        self.showsIndicators = showsIndicators
    }

    func makeUIViewController(context: Context) -> ImageViewerController {
        return ImageViewerController()
    }

    func updateUIViewController(_ viewController: ImageViewerController, context: Context) {
        viewController.setImage(image)
        viewController.scrollView.maximumZoomScale = maximumZoomScale
        viewController.scrollView.showsVerticalScrollIndicator = showsIndicators
        viewController.scrollView.showsHorizontalScrollIndicator = showsIndicators
    }
}

class ImageViewerController: UIViewController, UIScrollViewDelegate {
    private let imageView = UIImageView()
    fileprivate let scrollView = UIScrollView()

    func setImage(_ image: UIImage?) {
        imageView.image = image
        resetZoom(animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetZoom(animated: false)
    }

    @objc private func didDoubleTap(_ sender: UITapGestureRecognizer) {
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
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(image: UIImage(named: "demoImage"))
            .ignoresSafeArea()
    }
}
