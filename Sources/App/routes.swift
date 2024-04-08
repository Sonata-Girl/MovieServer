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
    app.get("moviesOld", ":genre") { req async throws -> String in
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
    app.get("moviesOld", ":genre", ":year") { req async throws -> String in
        guard let genre = req.parameters.get("genre"),
            let year = req.parameters.get("year")
        else {
            throw Abort(.badRequest)
        }

        return "All movies of genre: \(genre) for year \(year)"
    }

    app.get("moviesOld") { req async in
        [Film(title: "Batman", year: 2023), Film(title: "Spiderman", year: 2022)]
    }

    app.post("moviesOld") { req async throws in
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

    // create movie in postgres
    app.post("movies") { req async throws in
        let movie = try req.content.decode(Movie.self)
        try await movie.save(on: req.db)
        return movie
    }

    // get all movies
    app.get("movies") { req async throws in
        try await Movie.query(on: req.db)
            .all()
    }

    // get movie by id
    // /movie/08AFB2BE-EA28-4543-B990-D2637D93DE71
    app.get("movies", ":id") { req async throws in
        guard let movie = try await Movie.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest)
        }

        return movie
    }

    // delete movie by id
    // /movie/08AFB2BE-EA28-4543-B990-D2637D93DE71
    app.delete("movies", ":id") { req async throws in
        guard let movie = try await Movie.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest)
        }
        try await movie.delete(on: req.db)
        return movie
    }

    // update movie by id
    // /movie/08AFB2BE-EA28-4543-B990-D2637D93DE71
    app.put("movies") { req async throws in
        let editedMovie = try req.content.decode(Movie.self)
        guard let movieToUpdate = try await Movie.find(editedMovie.id, on: req.db) else {
            throw Abort(.badRequest)
        }

        movieToUpdate.title = editedMovie.title

        try await movieToUpdate.update(on: req.db)
        return movieToUpdate
    }

}
