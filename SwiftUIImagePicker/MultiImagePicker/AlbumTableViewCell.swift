//
//  AlbumTableViewCell.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/24/20.
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
