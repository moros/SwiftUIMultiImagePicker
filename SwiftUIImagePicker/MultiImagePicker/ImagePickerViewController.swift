//
//  ImagePickerViewController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/17/20.
//

import Photos
import UIKit

public class ImagePickerViewController: UIViewController {
    
    /// Delegate for Image Picker. Notifies when images are selected (done is tapped) or when the Image Picker is cancelled.
    ///
    weak var delegate: ImagePickerControllerDelegate?
    
    /// `UICollectionView` for displaying photo library images
    ///
    weak var collectionView: UICollectionView?
    
    /// Maximum photo selections allowed in picker (zero or fewer means unlimited).
    ///
    var maximumSelectionsAllowed: Int = -1
    
    /// Defends expected width size of image.
    var numberOfPhotosInRow: Int = 3
    
    /// Minimum amount of spacing between images.
    var imageMinimumInteritemSpacing: CGFloat = 6
    
    private var photoAssets: PHFetchResult<PHAsset> = PHFetchResult()
    private var selectedAssetIds: [String] = []
    
    internal lazy var fetchOptions: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }()
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot init \(String(describing: ImagePickerViewController.self)) from Interface Builder")
    }
    
    open override func loadView() {
        view = UIView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        guard let view = view else { return }
        fetchPhotos()
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: ImagePickerCollectionViewLayout(numberOfItemsAcross: self.numberOfPhotosInRow, minimumInteritemSpacing: self.imageMinimumInteritemSpacing))
        setup(collectionView: collectionView)
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        var constraints: [NSLayoutConstraint] = []
        constraints += [view.constraintEqualTo(with: collectionView, attribute: .top)]
        constraints += [view.constraintEqualTo(with: collectionView, attribute: .right)]
        
        //Lower priority to override left constraint for animations
        let leftCollectionViewConstraint = view.constraintEqualTo(with: collectionView, attribute: .left)
        leftCollectionViewConstraint.priority = UILayoutPriority(rawValue: 999)
        constraints += [leftCollectionViewConstraint]
        
        constraints += [view.constraintEqualTo(with: collectionView, attribute: .bottom)]
        NSLayoutConstraint.activate(constraints)
        view.layoutIfNeeded()
    }
    
    private func setup(collectionView: UICollectionView) {
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCollectionViewCell.reuseId)
    }
    
    private func fetchPhotos() {
        requestPhotoAccessIfNeeded(PHPhotoLibrary.authorizationStatus())
        
        photoAssets = PHAsset.fetchAssets(with: fetchOptions)
        collectionView?.reloadData()
    }
    
    private func requestPhotoAccessIfNeeded(_ status: PHAuthorizationStatus) {
        guard status == .notDetermined else { return }
        PHPhotoLibrary.requestAuthorization { [weak self] (_) in
            DispatchQueue.main.async { [weak self] in
                self?.photoAssets = PHAsset.fetchAssets(with: self?.fetchOptions)
                self?.collectionView?.reloadData()
            }
        }
    }
}

extension ImagePickerViewController: UICollectionViewDelegate {
    
    /// Collection View did select item at `IndexPath`
    ///
    /// - Parameter collectionView: the `UICollectionView`
    /// - Parameter indexPath: the `IndexPath`
    ///
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCollectionViewCell else {
            return
        }
        guard let asset = cell.photoAsset else {
            return
        }
        
        self.selectedAssetIds.append(asset.localIdentifier)
        self.delegate?.imagePicker?(self, didPickAssetIdentifiers: self.selectedAssetIds)
    }
    
    /// Collection View did de-select item at `IndexPath`
    ///
    /// - Parameter collectionView: the `UICollectionView`
    /// - Parameter indexPath: the `IndexPath`
    ///
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCollectionViewCell else {
            return
        }
        guard let asset = cell.photoAsset else {
            return
        }
        
        if let firstIndex = self.selectedAssetIds.firstIndex(of: asset.localIdentifier) {
            self.selectedAssetIds.remove(at: firstIndex)
        }
        
        self.delegate?.imagePicker?(self, didPickAssetIdentifiers: self.selectedAssetIds)
    }
    
    /// When user tries to select content, this method is triggered
    /// to determine if user can select item at the specified index
    /// path.
    ///
    /// - Parameter collectionView: the `UICollectionView`
    /// - Parameter indexPath: the `IndexPath`
    /// - Returns: Returns the boolean indicating whether item will be selected.
    ///
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCollectionViewCell,
            cell.imageView.image != nil else { return false }
        guard maximumSelectionsAllowed > 0 else { return true }
        
        let collectionViewItems = self.collectionView?.indexPathsForSelectedItems?.count ?? 0
        if self.maximumSelectionsAllowed <= collectionViewItems {
            let message = "imagepicker.maximum.selection".localized(withArguments: self.maximumSelectionsAllowed)
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok.label".localized(), style: .cancel, handler: nil)
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension ImagePickerViewController: UICollectionViewDataSource {
    
    /// Returns Collection View Cell for item at `IndexPath`
    ///
    /// - Parameter collectionView: the `UICollectionView`
    /// - Parameter indexPath: the `IndexPath`
    /// - Returns: Returns the `UICollectionViewCell`
    ///
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.reuseId, for: indexPath) as? ImagePickerCollectionViewCell else { return UICollectionViewCell() }
        let photoAsset = photoAssets.object(at: indexPath.item)
        cell.indexPath = indexPath
        cell.photoAsset = photoAsset
        cell.size = layoutAttributes.frame.size
        
        return cell
    }
    
    /// Returns the number of items in a given section
    ///
    /// - Parameter collectionView: the `UICollectionView`
    /// - Parameter section: the given section of the `UICollectionView`
    /// - Returns: Returns an `Int` for the number of rows.
    ///
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
}
