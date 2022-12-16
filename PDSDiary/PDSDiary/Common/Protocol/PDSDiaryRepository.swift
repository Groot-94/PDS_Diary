//
//  PDSDiaryRepository.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//

import Foundation

protocol PDSDiaryRepository {
    func create(model: DiaryModel)
    func read() async -> Result<[DiaryModel], Error>
    func update(_ model: DiaryModel)
    func delete(date: Date)
}
