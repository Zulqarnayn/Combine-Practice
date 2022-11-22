//
//  ViewController.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 21/11/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	let catViewModel = CatViewModel()
	var cancellables = Set<AnyCancellable>()
	
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
	typealias Datasource = UICollectionViewDiffableDataSource<Section, Book>
	
	enum Section: Hashable {
		case cat
	}
	
	private lazy var dataSource = makeDataSource()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		collectionView.register(cellFromNib: CatCollectionViewCell.self)
		
		catViewModel.fetchNextPage()
		
		catViewModel.dataSubject
			.sink(receiveValue: self.applySnapshot)
			.store(in: &cancellables)
		
		applySnapshot(books: [])
	}
	
	func  makeDataSource() -> Datasource {
		let dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, book) -> UICollectionViewCell? in
			return self.cell(collectionView: collectionView, indexPath: indexPath, item: book)
		}
		return dataSource
	}
	
	func applySnapshot(books: [Book]) {
		var snapshot = Snapshot()
		snapshot.appendSections([.cat])
		snapshot.appendItems(books, toSection: Section.cat)
		
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Book) -> UICollectionViewCell {
		let cell: CatCollectionViewCell = collectionView.dequeue(for: indexPath)
		
		cell.cancellable = self.catViewModel
			.fetchImage(from: item.url)
			.sink(receiveCompletion: { completion in
				// handle errors if needed
			}, receiveValue: { image in
				DispatchQueue.main.async {
					cell.catImageView.image = image
				}
			})

		return cell
	}

	@IBAction func loadNext(_ sender: UIButton) {
		
		catViewModel.fetchNextPage()
	}
}


