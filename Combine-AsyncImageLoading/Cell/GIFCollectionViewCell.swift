//
//  GIFCollectionViewCell.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 29/11/22.
//

import UIKit
import Combine

class GIFCollectionViewCell: UICollectionViewCell, CellFromNib {

    @IBOutlet weak var gifImageView: UIImageView!
    var cancellable: Cancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
