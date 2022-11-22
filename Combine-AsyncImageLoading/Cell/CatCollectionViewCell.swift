//
//  CatCollectionViewCell.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 21/11/22.
//

import UIKit
import Combine

class CatCollectionViewCell: UICollectionViewCell, CellFromNib {

	@IBOutlet weak var catImageView: UIImageView!
	var cancellable: Cancellable?
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		catImageView.image = nil
	}

}
