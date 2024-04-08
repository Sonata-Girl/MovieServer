//
//  MovieController.swift
//
//
//  Created by Sonata Girl on 08.04.2024.
//

import Vapor

struct MoviesController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let movies = routes.grouped("newMovies")
        // /movies
        movies.get(use: index)

        // /movie/23
        movies.get(":movieId", use: show)
    }

    func index(req: Request) async throws -> String {
        return "Index"
    }

    func show(req: Request) async throws -> String {
        guard let movieId = req.parameters.get("movieId") else {
            throw Abort(.internalServerError)
        }
        
        return "\(movieId)"
    }
}
