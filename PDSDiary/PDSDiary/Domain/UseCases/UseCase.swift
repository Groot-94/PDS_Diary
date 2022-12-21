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
    
    func create(model: DiaryModel) async {
        await repository.create(model: model)
    }
    
    func read() async -> Result<[DiaryModel], Error> {
        return await repository.read()
    }
    
    func update(_ model: DiaryModel) async {
        await repository.update(model)
    }
    
    func delete(date: Date) async {
        await repository.delete(date: date)
    }
}
