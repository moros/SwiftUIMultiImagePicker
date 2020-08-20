//
//  AlbumsViewController.swift
//  SwiftUIImagePicker
//
//  Created by dmason on 8/20/20.
//  Copyright © 2020 United Fire Group. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    var onDismiss: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = .red
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.onDismiss != nil {
            self.onDismiss!()
        }
    }
}
