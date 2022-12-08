//
//  GIFViewModel.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 29/11/22.
//

import Foundation
import Combine

let tenorKey = "AIzaSyCPQ3TExutoV7WiZ2gZ9bO8dAZufqI2rSk"

class GIFViewModel {
    let subject = CurrentValueSubject<[GIFResult], Never>([])
    var cancellables = Set<AnyCancellable>()
    
    func requestData(for searchText: String, limit: Int = 10) {
        guard let url = URL(string: "https://tenor.googleapis.com/v2/search?q=\(searchText)&key=\(tenorKey)&limit=\(limit)") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                let jsonDecoder = JSONDecoder()
                if let tenorResult = try? jsonDecoder.decode(Tenor.self, from: value.data) {
                    self.subject.value += tenorResult.results
                }
            }).store(in: &cancellables)
    }
}

struct Tenor: Codable {
    let results: [GIFResult]
    let next: String
}

// MARK: - Result
struct GIFResult: Codable, Hashable {
    let id: String
    let title: String
    let url: String
}
