//
//  ImageCollectionCell.swift
//  ImageLoading
//
//  Created by Karun Aggarwal on 22/04/24.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    /// IBOutlets
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Properties
    
    /// Intialise Controller
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
