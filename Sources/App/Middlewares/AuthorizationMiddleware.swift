//
//  AuthorizationMiddleware.swift
//
//
//  Created by Sonata Girl on 08.04.2024.
//

import Foundation
import Vapor

struct AuthorizationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Headers: Authorization: Bearer EDRF1223123ASDSD

        guard let auth = request.headers.bearerAuthorization else {
            // Пользователь не имеет доступа и не прошел авторизацию и выдаем ошибку
            throw Abort(.unauthorized)
        }

        print(auth.token)
        return try await next.respond(to: request)
    }
}
