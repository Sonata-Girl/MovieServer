import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.databases.use(.postgres(
        hostname: "ella.db.elephantsql.com",
        username: "cszpuuez",
        password: "SB-AIKn8JZjKFbAN8Zutrb_pbp8Qs0KL",
        database: "cszpuuez"
    ), as: .psql)

    app.migrations.add(CreateMoviesTableMigration())

    // register routes
    try routes(app)
}
