//
//  CoreDataRepository.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/12.
//

import Foundation

final class CoreDataRepository: PDSDiaryRepository {
    private let coreDataManager: CoreDataManager<DiaryModel>
    
    init() {
        self.coreDataManager = CoreDataManager<DiaryModel>(modelName: "PDSDiary", entityName: "PDSModel")
    }
    
    func create(model: DiaryModel) {
        let dictionnary = [
            "date": model.date,
            "plan": model.plan,
            "doing": model.doing,
            "feedback": model.feedback,
            "grade": model.grade.rawValue
        ] as [String: Any]
        
        coreDataManager.create(entityKeyValue: dictionnary)
    }
    
    func read(completion: @escaping (Result<[DiaryModel], Error>) -> Void) {
        switch coreDataManager.read(request: PDSModel.fetchRequest()) {
        case .success(let fetchList):
            let models = fetchList.map {
                DiaryModel(date: $0.date ?? Date(),
                      plan: $0.plan ?? "",
                      doing: $0.doing ?? "",
                      feedback: $0.feedback ?? "",
                      grade: Grade(rawValue: $0.grade ?? "") ?? .none)
            }
            
            completion(.success(models))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func update(_ model: DiaryModel) {
        switch coreDataManager.read(request: PDSModel.fetchRequest()) {
        case .success(let fetchList):
            guard let filteredList = fetchList.filter({ $0.date == model.date }).first else { return }
            
            let dictionnary = [
                "date": model.date,
                "plan": model.plan,
                "doing": model.doing,
                "feedback": model.feedback,
                "grade": model.grade.rawValue
            ] as [String: Any]
            
            coreDataManager.update(object: filteredList, entityKeyValue: dictionnary)
        case .failure(let error):
            print(error)
        }
    }
    
    func delete(date: Date) {
        switch coreDataManager.read(request: PDSModel.fetchRequest()) {
        case .success(let fetchList):
            guard let object = fetchList.filter({ $0.date == date }).first else { return }
            
            coreDataManager.delete(object: object)
        case .failure(let error):
            print(error)
        }
    }
}
