//
//  GIFViewController.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 29/11/22.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
  }

class GIFViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GIFResult>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, GIFResult>
    
    @Published var searchQuery = ""
    
    enum Section: Hashable {
        case gif
    }
    
    let gifViewModel = GIFViewModel()
    
    private lazy var dataSource = makeDataSource()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(cellFromNib: GIFCollectionViewCell.self)
        
        createSubscription()
    }
    
    func createSubscription() {
        gifViewModel.subject
            .sink(receiveValue: self.applySnapshot)
            .store(in: &cancellables)
        
        searchBar.searchTextField.textPublisher
            .sink { searchQuery in
                print(searchQuery)
                self.searchQuery = searchQuery
            }.store(in: &cancellables)
        
        applySnapshot(gifs: [])
        
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .filter { $0.count > 2 }
            .removeDuplicates()
            .sink { str in
                self.gifViewModel.requestData(for: str)
            }
            .store(in: &cancellables)
    }
    
    func  makeDataSource() -> Datasource {
        let dataSource = Datasource(collectionView: collectionView) { (collectionView, indexPath, book) -> UICollectionViewCell? in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: book)
        }
        return dataSource
    }
    
    func applySnapshot(gifs: [GIFResult]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.gif])
        snapshot.appendItems(gifs, toSection: Section.gif)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: GIFResult) -> UICollectionViewCell {
        let cell: GIFCollectionViewCell = collectionView.dequeue(for: indexPath)
        
//        cell.cancellable = self.gifViewModel
//            .requestData(for: <#String#>, from: item.url)
//            .sink(receiveCompletion: { completion in
//                // handle errors if needed
//            }, receiveValue: { image in
//                DispatchQueue.main.async {
//                    cell.catImageView.image = image
//                }
//            })
        
        return cell
    }
}
