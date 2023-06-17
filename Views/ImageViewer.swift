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
    let maximumZoomScale: CGFloat = 3.0
    let showsVerticalScrollIndicator: Bool = false
    let showsHorizontalScrollIndicator: Bool = false

    func makeUIViewController(context: Context) -> ImageViewerController {
        ImageViewerController(image: image)
    }

    func updateUIViewController(_ viewController: ImageViewerController, context: Context) {
        viewController.setImage(image)
        viewController.scrollView.maximumZoomScale = maximumZoomScale
        viewController.scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        viewController.scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    }
}

class ImageViewerController: UIViewController, UIScrollViewDelegate {
    private let imageView: UIImageView
    private let containerView: UIView
    let scrollView: UIScrollView

    private let useContainerView = true

    init(image: UIImage?) {
        imageView = UIImageView(image: image)
        scrollView = UIScrollView()
        containerView = UIView()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup views
        scrollView.delegate = self

        if useContainerView {
            view.addSubview(scrollView)

            scrollView.addSubview(containerView)
            containerView.addSubview(imageView)

            // Setup constraints
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

                imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            ])
        } else {
            view.addSubview(scrollView)
            scrollView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit

            // Setup constraints
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            ])
        }

        // Add double tap to zoom gesture
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }

    @objc private func didDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let zoomScale: CGFloat = 2.0
            let point = sender.location(in: containerView)
            let zoomRect = CGSize(
                width: scrollView.contentSize.width / zoomScale,
                height: scrollView.contentSize.height / zoomScale
            )
            scrollView.zoom(to: CGRect(origin: point, size: zoomRect), animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if useContainerView {
            updateMinZoomScaleForSize(scrollView.frame.size)
        }
    }

    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if useContainerView {
            return containerView
        } else {
            return imageView
        }
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(image: UIImage(named: "demoImage"))
            .ignoresSafeArea()
    }
}
