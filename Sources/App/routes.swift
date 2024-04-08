import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: MoviesController())
    app.middleware.use(LogMiddleware())

    app.grouped(AuthorizationMiddleware()).group("members") { route in
        route.get { req async -> String in
            return "Members Index"
        }

        route.get("hello") { req async -> String in
            return "Members hello"
        }
    }

    app.get { req async in
        "get"
    }

    app.get("hello") { req async in
        "hello"
    }

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
        [Film(title: "Batman", year: 2023), Film(title: "Spiderman", year: 2022)]
    }

    app.post("movies") { req async throws in
        let movie = try req.content.decode(Film.self)
        return movie
    }
    
    // /hotels?sort=dec&search=houston
    app.get("hotels") { req async throws in
        let hotelQuery = try req.query.decode(HotelQuery.self)
        return hotelQuery
    }

    // /movies
    // /movies/12
    let movies = app.grouped("moviesNew")

    // /users
    // /users/premium
    let users = app.grouped("users")

    // /movies
    movies.get { req async -> String in
        return "moviesNew"
    }
    // /movies/34
    movies.get(":movieId") { req async throws -> String in
        guard let movieId = req.parameters.get("movieId") else {
            throw Abort(.badRequest)
        }

        return "MovieId = \(movieId)"
    }
    // /users
    // /users/premium
    users.get { req async -> String in
        return "users"
    }

    users.get("premium") { req async -> String in
        return "premium"
    }
}
