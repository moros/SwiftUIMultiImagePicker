//
//  AlbumsViewController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import Foundation
import Photos
import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    static let reuseId = String(describing: AlbumTableViewCell.self)
    
    let albumImageView: UIImageView = UIImageView(frame: .zero)
    let albumTitleLabel: UILabel = UILabel(frame: .zero)

    override var isSelected: Bool {
        didSet {
            if isSelected {
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        self.albumImageView.translatesAutoresizingMaskIntoConstraints = false
        self.albumImageView.contentMode = .scaleAspectFill
        self.albumImageView.clipsToBounds = true
        self.contentView.addSubview(albumImageView)
        
        self.albumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.albumTitleLabel.numberOfLines = 0
        self.contentView.addSubview(albumTitleLabel)
        
        NSLayoutConstraint.activate([
            self.albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            self.albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            self.albumImageView.widthAnchor.constraint(equalToConstant: 84),
            self.albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            self.albumTitleLabel.leadingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: 8),
            self.albumTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            self.albumTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.albumTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumImageView.image = nil
        self.albumTitleLabel.text = nil
    }
}

class AlbumsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var assetSettings: AssetSettings = AssetSettings.shared
    private let albums: [PHAssetCollection]
    private let scale: CGFloat
    private let imageManager = PHCachingImageManager.default()
    
    init(albums: [PHAssetCollection], scale: CGFloat = UIScreen.main.scale) {
        self.albums = albums
        self.scale = scale
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.albums.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseId, for: indexPath) as! AlbumTableViewCell
        
        let album = self.albums[indexPath.row]
        
        cell.albumTitleLabel.attributedText = self.title(forAlbum: album)
        
        let fetchOptions = self.assetSettings.fetchOptions.copy() as! PHFetchOptions
        fetchOptions.fetchLimit = 1
        
        let imageSize = CGSize(width: 84, height: 84).resize(by: self.scale)
        let mode: PHImageContentMode = .aspectFill
        if let asset = PHAsset.fetchAssets(in: album, options: fetchOptions).firstObject {
            self.imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: mode, options: self.assetSettings.photoOptions) { (image, _) in
                guard let image = image else {
                    return
                }
                
                cell.albumImageView.image = image
            }
        }
        
        return cell
    }
    
    private func title(forAlbum album: PHAssetCollection) -> NSAttributedString {
        return NSAttributedString(string: album.localizedTitle ?? "", attributes: self.albumTitleAttributes)
    }
    
    private lazy var albumTitleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
        NSAttributedString.Key.foregroundColor: UIColor.label
    ]
}

protocol AlbumsViewControllerDelegate: class {
    func albumsViewController(_ viewController: AlbumsViewController, didSelectAlbum ablum: PHAssetCollection)
}

class AlbumsViewController: UIViewController {
    
    var onDismiss: (() -> Void)? = nil
    var albums: [PHAssetCollection] = []
    var configuration: DropdownConfiguration = DropdownConfiguration.shared
    
    private var dataSource: AlbumsTableViewDataSource?
    private weak var tableView: UITableView!
    
    weak var delegate: AlbumsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.tableView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.onDismiss != nil {
            self.onDismiss!()
        }
    }
    
    private func setup() {
        guard let view = self.view else {
            return
        }
        
        let tableView = self.makeTableView()
        view.addSubview(tableView)
        self.tableView = tableView
        
        var constraints: [NSLayoutConstraint] = []
        constraints += [view.constraintEqualTo(with: tableView, attribute: .top, constant: 8)]
        constraints += [view.constraintEqualTo(with: tableView, attribute: .right, constant: 8)]
        constraints += [view.constraintEqualTo(with: tableView, attribute: .left, constant: -8)]
        constraints += [view.constraintEqualTo(with: tableView, attribute: .bottom, constant: 8)]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func makeTableView() -> UITableView {
        self.dataSource = AlbumsTableViewDataSource(albums: self.albums)
        
        let tableView: UITableView = UITableView()
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.reuseId)
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.sectionHeaderHeight = .leastNormalMagnitude
        tableView.sectionFooterHeight = .leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        
        return tableView
    }
}

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = self.albums[indexPath.row]
        self.delegate?.albumsViewController(self, didSelectAlbum: album)
        self.dismiss(animated: true, completion: nil)
    }
}
