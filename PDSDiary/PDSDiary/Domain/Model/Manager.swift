//
//  Manager.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//

final class Manager: PDSDiaryManager {
    let useCase: UseCase
    
    init() {
        self.useCase = UseCase(repository: CoreDataRepository())
    }
}
