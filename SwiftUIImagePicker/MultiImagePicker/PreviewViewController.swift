//
//  PreviewViewController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/25/20.
//

import CoreLocation
import Photos
import UIKit

internal class PreviewViewController: UIViewController {
    
    private let imageManager = PHCachingImageManager.default()
    private let scrollView = UIScrollView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let singleTapRecognizer = UITapGestureRecognizer()
    private let doubleTapRecognizer = UITapGestureRecognizer()
    
    override var prefersStatusBarHidden: Bool {
        return self.fullscreen
    }
    
    var asset: PHAsset? {
        didSet {
            guard let asset = asset else {
                self.imageView.image = nil
                return
            }
            
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: self.photoOptions) { [weak self] (image, _) in
                guard let image = image else {
                    return
                }
                
                self?.imageView.image = image
            }
        }
    }
    
    var fullscreen = false {
        didSet {
            guard oldValue != fullscreen else {
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(self.fullscreen, animated: true)
                self.setNeedsStatusBarAppearanceUpdate()
                self.updateBackgroundColor()
            }
        }
    }
    
    lazy var photoOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        return options
    }()
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        self.setupScrollView()
        self.setupImageView()
        self.setupSingleTapRecognizer()
        self.setupDoubleTapRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBackgroundColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.fullscreen = false
    }
    
    @objc func didSingleTap(_ recognizer: UIGestureRecognizer) {
        self.fullscreen.toggle()
    }
    
    @objc func didDoubleTap(_ recognizer: UIGestureRecognizer) {
        switch self.scrollView.zoomScale {
        case _ where self.scrollView.zoomScale > 1:
            self.scrollView.setZoomScale(1, animated: true)
        default:
            let rect = self.zoomRect(scale: 2, center: recognizer.location(in: recognizer.view))
            self.scrollView.zoom(to: rect, animated: true)
        }
    }
    
    private func setupScrollView() {
        self.scrollView.frame = self.view.bounds
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 3
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
    }
    
    private func setupImageView() {
        self.imageView.frame = self.scrollView.bounds
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(self.imageView)
    }
    
    private func setupSingleTapRecognizer() {
        self.singleTapRecognizer.numberOfTapsRequired = 1
        self.singleTapRecognizer.addTarget(self, action: #selector(didSingleTap(_:)))
        self.singleTapRecognizer.require(toFail: self.doubleTapRecognizer)
        self.view.addGestureRecognizer(self.singleTapRecognizer)
    }
    
    private func setupDoubleTapRecognizer() {
        self.doubleTapRecognizer.numberOfTapsRequired = 2
        self.doubleTapRecognizer.addTarget(self, action: #selector(didDoubleTap(_:)))
        self.view.addGestureRecognizer(self.doubleTapRecognizer)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        guard let zoomView = self.viewForZooming(in: self.scrollView) else {
            return .zero
        }
        
        let newCenter = self.scrollView.convert(center, from: zoomView)
        var rect = CGRect.zero
        rect.size.height = zoomView.frame.size.height / scale
        rect.size.width = zoomView.frame.size.width / scale
        rect.origin.x = newCenter.x - (rect.size.width / 2.0)
        rect.origin.y = newCenter.y - (rect.size.height / 2.0)
        
        return rect
    }
    
    private func updateBackgroundColor() {
        if self.fullscreen && self.modalPresentationStyle == .fullScreen {
            self.view.backgroundColor = UIColor.black
        } else {
            self.view.backgroundColor = UIColor.systemBackground
        }
    }
}

extension PreviewViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard scrollView.zoomScale > 1 else {
            scrollView.contentInset = .zero
            return
        }
        
        func computeScale(value: CGFloat) -> CGFloat {
            return value * scrollView.zoomScale
        }
        
        self.fullscreen = true
        guard let image = self.imageView.image else { return }
        guard let zoomView = self.viewForZooming(in: scrollView) else { return }
        
        let widthRatio = zoomView.frame.width / image.size.width
        let heightRatio = zoomView.frame.height / image.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio
        
        let half = CGFloat(0.5)
        let left = half * ( computeScale(value: newWidth) > zoomView.frame.width
            ? (newWidth - zoomView.frame.width)
            : (scrollView.frame.width - scrollView.contentSize.width)
        )
        let top = half * ( computeScale(value: newHeight) > zoomView.frame.height
            ? (newHeight - zoomView.frame.height)
            : (scrollView.frame.height - scrollView.contentSize.height)
        )
        
        scrollView.contentInset = UIEdgeInsets(
            top: top.rounded(),
            left: left.rounded(),
            bottom: top.rounded(),
            right: left.rounded()
        )
    }
}
