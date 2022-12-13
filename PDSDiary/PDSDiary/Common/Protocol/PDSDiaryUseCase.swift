//
//  PDSDiaryUseCase.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//

import Foundation

protocol PDSDiaryUseCase {
    func create(model: Model)
    func read(completion: @escaping (Result<[Model], Error>) -> Void)
    func update(_ model: Model)
    func delete(date: Date)
}
