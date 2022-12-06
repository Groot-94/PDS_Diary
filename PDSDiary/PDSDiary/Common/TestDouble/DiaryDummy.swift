//
//  DiaryDummy.swift
//  PDSDiary
//
//  Created by Groot on 2022/12/05.
//

import Foundation

enum DiaryDummy {
    static var dictionary =
    [
        Date().convert():
            [
                PDSModel(date: Date(), plan: "할거야1", doing: "한다1", feedback: "잘했다1", grade: .good),
                PDSModel(date: Date(), plan: "할거야2", doing: "한다2", feedback: "잘했다2", grade: .soso),
                PDSModel(date: Date(), plan: "할거야3", doing: "한다3", feedback: "잘했다3", grade: .bad),
                PDSModel(date: Date(), plan: "할거야4", doing: "한다4", feedback: "잘했다4", grade: .none),
                PDSModel(date: Date(), plan: "할거야5", doing: "한다4", feedback: "잘했다4", grade: .none),
                PDSModel(date: Date(), plan: "할거야6", doing: "한다4", feedback: "잘했다4", grade: .none),
                PDSModel(date: Date(), plan: "할거야7", doing: "한다4", feedback: "잘했다4", grade: .none),
                PDSModel(date: Date(), plan: "할거야8", doing: "한다4", feedback: "잘했다4", grade: .none),
            ],
        "20221226":
            [
                PDSModel(date: Date(), plan: "할거야1", doing: "한다1", feedback: "잘했다1", grade: .good)
            ]
    ]
}
