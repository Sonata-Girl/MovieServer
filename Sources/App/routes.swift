import Vapor

func routes(_ app: Application) throws {

    // movies/anygenre
    // movies/kids
    // movies/horror
    // movies/action
    app.get("movies", ":genre") { req async throws -> String in
        guard let genre = req.parameters.get("genre") else {
            throw Abort(.badRequest)
        }
        return "All movies of genre: \(String(describing: genre))"
    }

    app.get("customers", ":customerId") { req async throws -> String in
        guard let customerId = req.parameters.get("customerId", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "\(customerId)"
    }

    // movies/action/2023
    app.get("movies", ":genre", ":year") { req async throws -> String in
        guard let genre = req.parameters.get("genre"),
            let year = req.parameters.get("year")
        else {
            throw Abort(.badRequest)
        }

        return "All movies of genre: \(genre) for year \(year)"
    }

    app.get("movies") { req async in
        [Movie(title: "Batman", year: 2023), Movie(title: "Spiderman", year: 2022)]
    }

    app.post("movies") { req async throws in
        let movie = try req.content.decode(Movie.self)
        return movie
    }

}
