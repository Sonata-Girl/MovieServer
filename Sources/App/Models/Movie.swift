//
//  File.swift
//  
//
//  Created by Sonata Girl on 08.04.2024.
//

import Foundation
import Fluent
import Vapor

final class Movie: Model {

    static let schema: String = "movies"

    // идентификатор фильма, первичный ключ
    // название столбца в базе данных
    @ID(key: .id)
    var id: UUID?

    // мы укажем что ключом поля будет название
    // это означает что название столбца будет title
    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
