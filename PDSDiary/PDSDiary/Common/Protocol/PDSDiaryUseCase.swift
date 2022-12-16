//
//  PDSDiaryUseCase.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//

import Foundation

protocol PDSDiaryUseCase {
    func create(model: DiaryModel)
    func read() async -> Result<[DiaryModel], Error>
    func update(_ model: DiaryModel)
    func delete(date: Date)
}
