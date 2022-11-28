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
    let themeManager: ThemeManager
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Book>
    
    enum Section: Hashable {
        case cat
    }
    
    private lazy var dataSource = makeDataSource()
    
    required init?(coder: NSCoder, themeManager: ThemeManager) {
        self.themeManager = themeManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(cellFromNib: CatCollectionViewCell.self)
        
        catViewModel.fetchNextPage()
        
        catViewModel.dataSubject
            .sink(receiveValue: self.applySnapshot)
            .store(in: &cancellables)
        
        applySnapshot(books: [])
        
        themeManager
            .$themeStyle
            .sink { style in
                DispatchQueue.main.async {
                    guard let window = UIApplication.shared.windows.first else {
                        return
                    }
                    print(style)
                    
                    if style == .dark {
                        window.overrideUserInterfaceStyle = .dark
                    } else if style == .light {
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            }.store(in: &cancellables)
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
    
    @IBAction func didTapSwitch(_ sender: UISwitch) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
        
        sceneDelegate.themeManager.shouldApplyDarkMode.toggle()
        sceneDelegate.themeManager.shouldOverrideSystemSetting.toggle()
    }
}


