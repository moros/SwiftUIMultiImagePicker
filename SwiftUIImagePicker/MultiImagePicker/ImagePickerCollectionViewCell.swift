//
//  ImagePickerCollectionViewCell.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/17/20.
//

import Photos
import UIKit

internal class ImagePickerCollectionViewCell: UICollectionViewCell {
    
    static let scale: CGFloat = 3
    static let reuseId = String(describing: ImagePickerCollectionViewCell.self)
    
    var photoAsset: PHAsset? {
        didSet {
            loadPhotoAssetIfNeeded()
        }
    }
    
    var size: CGSize? {
        didSet {
            loadPhotoAssetIfNeeded()
        }
    }
    
    var indexPath: IndexPath?
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            setSelected(newValue, animated: true)
        }
    }
    
    weak var overlayView: UIView?
    weak var overlayImageView: UIImageView?
    
    private var imageRequestID: PHImageRequestID?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.backgroundColor = UIColor.clear.cgColor
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.imageView)
        let constraints = self.contentView.constraintsToFill(otherView: self.imageView)
        
        NSLayoutConstraint.activate(constraints)
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholder")
        
        let manager = PHImageManager.default()
        guard let imageRequestID = self.imageRequestID else { return }
        manager.cancelImageRequest(imageRequestID)
        self.imageRequestID = nil
        
        setSelected(false, animated: false)
    }
    
    func setSelected(_ isSelected: Bool, animated: Bool) {
        super.isSelected = isSelected
        updateSelected(animated)
    }
    
    private func loadPhotoAssetIfNeeded() {
        guard
            let indexPath = self.indexPath,
            let asset = self.photoAsset,
            let size = self.size else {
            return
        }
        
        if let cachedImage = InMemoryImageCache.shared.image(forKey: asset.localIdentifier) {
            self.imageView.image = cachedImage
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let manager = PHImageManager.default()
        let newSize = CGSize(width: size.width * type(of: self).scale,
                             height: size.height * type(of: self).scale)
        
        self.imageRequestID = manager.requestImage(for: asset, targetSize: newSize, contentMode: .aspectFill, options: options, resultHandler: { [weak self] (result, _) in
            guard self?.indexPath?.item == indexPath.item else { return }
            //self?.activityIndicator.stopAnimating()
            
            if result != nil {
                InMemoryImageCache.shared.store(image: result!, forKey: asset.localIdentifier)
            }
            self?.imageRequestID = nil
            self?.imageView.image = result
        })
    }
    
    private func updateSelected(_ animated: Bool) {
        if self.isSelected {
            addOverlay(animated)
        } else {
            removeOverlay(animated)
        }
    }
    
    func getImage(image: UIImage, backgroundColor: UIColor)->UIImage?{

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        backgroundColor.setFill()
        
        let rect = CGRect(origin: .zero, size: image.size)
        let path = UIBezierPath(arcCenter: CGPoint(x:rect.midX, y:rect.midY), radius: rect.midX, startAngle: 0, endAngle: 6.28319, clockwise: true)
        path.fill()
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func addOverlay(_ animated: Bool) {
        guard self.overlayView == nil && self.overlayImageView == nil else { return }
        
        let overlayView = UIView(frame: frame)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overlayView)
        self.overlayView = overlayView
        
        let overlayImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.setBackground(color: .white))
        overlayImageView.contentMode = .topLeft
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(overlayImageView)
        self.overlayImageView = overlayImageView
        
        let overlayViewConstraints = overlayView.constraintsToFill(otherView: contentView)
        let overlayImageViewConstraints = overlayImageView.constraintsToFill(otherView: contentView)
        NSLayoutConstraint.activate(overlayImageViewConstraints + overlayViewConstraints)
        layoutIfNeeded()
        
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration, animations: {
            overlayView.alpha = 0.7
            overlayImageView.alpha = 1
        })
    }
    
    private func removeOverlay(_ animated: Bool) {
        guard let overlayView = self.overlayView,
            let overlayImageView = self.overlayImageView else {
                self.overlayView?.removeFromSuperview()
                self.overlayImageView?.removeFromSuperview()
                return
        }
        
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration, animations: {
            overlayView.alpha = 0
            overlayImageView.alpha = 0
        }, completion: { (_) in
            overlayView.removeFromSuperview()
            overlayImageView.removeFromSuperview()
        })
    }
}
