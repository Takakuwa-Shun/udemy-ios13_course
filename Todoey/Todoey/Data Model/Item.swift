//
//  Item.swift
//  Todoey
//
//  Created by 高桑駿 on 2020/04/20.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var color: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
