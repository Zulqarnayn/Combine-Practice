//
//  ViewModel.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 21/11/22.
//

import Foundation
import Combine
import UIKit

class CatViewModel {
	let dataSubject = CurrentValueSubject<[Book], Never>([])
	
	var currentPage = -1
	var cancellables = Set<AnyCancellable>()
	
	func fetchNextPage() {
		currentPage += 1
		let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=20&page=\(currentPage)")!
		print(currentPage)
		URLSession.shared.dataTaskPublisher(for: url)
			.sink(receiveCompletion: { _ in
				// handle completion
			}, receiveValue: { [weak self] value in
				guard let self = self else { return }
				
				let jsonDecoder = JSONDecoder()
				if let model = try? jsonDecoder.decode([Book].self, from: value.data) {
					self.dataSubject.value += model
				}
			}).store(in: &cancellables)
	}
	
	func fetchImage(from imageUrl: String) -> AnyPublisher<UIImage?, URLError> {
		let url = URL(string: imageUrl)!
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { result in
				return UIImage(data: result.data)
			}
			.eraseToAnyPublisher()
	}
}

