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

class AlbumsViewController: UIViewController {
    
    var onDismiss: (() -> Void)? = nil
    var albums: [PHAssetCollection] = []
    var selectedAssetCollection: PHAssetCollection? = nil
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
        self.dataSource = AlbumsTableViewDataSource(albums: self.albums, selectedAssetCollection: self.selectedAssetCollection)

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
        self.selectedAssetCollection = album
        self.delegate?.albumsViewController(self, didSelectAlbum: album)
        self.dismiss(animated: true, completion: nil)
    }
}
