//
//  UseCase.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//

import Foundation

final class UseCase: PDSDiaryUseCase {
    private let repository: PDSDiaryRepository
    
    init(repository: PDSDiaryRepository) {
        self.repository = repository
    }
    
    func create(model: DiaryModel) {
        repository.create(model: model)
    }
    
    func read(completion: @escaping (Result<[DiaryModel], Error>) -> Void) {
        repository.read(completion: completion)
    }
    
    func update(_ model: DiaryModel) {
        repository.update(model)
    }
    
    func delete(date: Date) {
        repository.delete(date: date)
    }
}
