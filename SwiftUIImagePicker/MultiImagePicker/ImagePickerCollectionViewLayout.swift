//
//  ImagePickerCollectionViewLayout.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/17/20.
//

import UIKit

internal class ImagePickerCollectionViewLayout: UICollectionViewLayout {

    let numberOfItemsAcross: Int
    var minimumInteritemSpacing: CGFloat
    
    init(numberOfItemsAcross: Int, minimumInteritemSpacing: CGFloat) {
        self.numberOfItemsAcross = numberOfItemsAcross
        self.minimumInteritemSpacing = minimumInteritemSpacing
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sizeOfItem: CGFloat = 0
    private var cellLayoutInfo: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    /// Prepare for Collection View Update
    ///
    /// - Parameter updateItems: Items to update
    ///
    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        updateItemSizes()
    }
    
    /// Prepare the layout
    ///
    override func prepare() {
        updateItemSizes()
    }
    
    /// Returns `Bool` telling should invalidate layout
    ///
    /// - Parameter newBounds: the new bounds
    /// - Returns: Returns a `Bool` telling should invalidate layout
    ///
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// Returns layout attributes for indexPath
    ///
    /// - Parameter indexPath: the `IndexPath`
    /// - Returns: Returns layout attributes
    ///
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellLayoutInfo[indexPath]
    }
    
    /// Returns a list of layout attributes for items in rect
    ///
    /// - Parameter rect: the Rect
    /// - Returns: Returns a list of layout attributes
    ///
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        return cellLayoutInfo.filter { (indexPath, layoutAttribute) -> Bool in
            return layoutAttribute.frame.intersects(rect) && indexPath.item < numberOfItems
            }.map { $0.value }
    }
    
    /// these values represent the width and height of all the content,
    /// not just the content that is currently visible.
    ///
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        
        guard numberOfItemsAcross > 0 else { return CGSize.zero }
        let widthOfItem = collectionView.bounds.width/CGFloat(numberOfItemsAcross)
        sizeOfItem = widthOfItem
        
        var totalNumberOfItems = 0
        for section in 0..<collectionView.numberOfSections {
            totalNumberOfItems += collectionView.numberOfItems(inSection: section)
        }
        
        let numberOfRows = Int(ceilf(Float(totalNumberOfItems)/Float(numberOfItemsAcross)))
        
        let insets = collectionView.contentInset
        var size = collectionView.frame.size
        size.width = collectionView.bounds.width - (insets.left + insets.right)
        size.height = CGFloat(numberOfRows) * widthOfItem
        return size
    }
    
    private func updateItemSizes() {
        guard let collectionView = self.collectionView else { return }
        
        guard numberOfItemsAcross > 0 else { return }
        let widthOfItem = (collectionView.bounds.width - self.minimumInteritemSpacing)/CGFloat(numberOfItemsAcross)
        sizeOfItem = widthOfItem
        
        cellLayoutInfo = [:]
        
        var yPosition: CGFloat = 0
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let column = item % numberOfItemsAcross
                
                let xPosition = CGFloat(column) * widthOfItem
                layoutAttributes.frame = CGRect(x: xPosition + self.minimumInteritemSpacing, y: yPosition, width: widthOfItem - self.minimumInteritemSpacing, height: widthOfItem - self.minimumInteritemSpacing)
                cellLayoutInfo[indexPath] = layoutAttributes
                
                //When at the end of row increment y position.
                if column == numberOfItemsAcross-1 {
                    yPosition += widthOfItem
                }
            }
        }
    }
}
