//
//  Category.swift
//  Todoey
//
//  Created by 高桑駿 on 2020/04/20.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
