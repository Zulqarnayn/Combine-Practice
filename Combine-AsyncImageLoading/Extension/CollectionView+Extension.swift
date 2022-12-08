//
//  CollectionView+Extension.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 21/11/22.
//

import UIKit

protocol CellFromNib: UICollectionViewCell {
	
}

extension CellFromNib {
	static var nib: UINib {
		return UINib(nibName: String(describing: Self.self), bundle: nil)
	}
}

extension UICollectionReusableView {
	static var reuseIdentifier: String {
		return String(describing: Self.self)
	}
}

extension UICollectionView {
	
	func register<T: CellFromNib>(cellFromNib: T.Type) {
		register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
	}
	
	func register<T: UICollectionViewCell>(cell: T.Type) {
		register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
	}
	
	func register<T: UICollectionReusableView>(header: T.Type) {
		register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
	}
	
	func register<T: UICollectionReusableView>(footer: T.Type) {
		register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
	}
	
	func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
		return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
	}
}
