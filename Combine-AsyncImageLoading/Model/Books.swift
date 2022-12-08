//
//  Books.swift
//  Combine-AsyncImageLoading
//
//  Created by Asif Mujtaba on 21/11/22.
//

import Foundation

struct Book: Codable, Hashable {
	let id: String
	let url: String
	let width, height: Int
}

typealias Books = [Book]
