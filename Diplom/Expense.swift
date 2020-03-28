//
//  Expense.swift
//  Diplom
//
//  Created by Admin on 27.03.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class Expense: Object {
    @objc dynamic var type: String = "Транспорт"
    @objc dynamic var imageName: String = "car.fill"
    @objc dynamic var value: Double = 0
    @objc dynamic var date: Date = Date()
}

class UserDate: Object {
    @objc dynamic var balance: Double = 0
}
