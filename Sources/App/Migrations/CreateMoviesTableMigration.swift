//
//  CreateMoviesTableMigration.swift
//
//
//  Created by Sonata Girl on 08.04.2024.
//

import Foundation
import Fluent

struct CreateMoviesTableMigration: AsyncMigration {
   
    func prepare(on database: FluentKit.Database) async throws {
        // create movies table
        try await database.schema("movies")
            .id() //    создаем идентификатор столбца
            .field("title", .string, .required)
            .create()
    }

    // запускается когда перенос будет отменен
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("movies")
            .delete()
    }

}
