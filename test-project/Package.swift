// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "test-project",
    dependencies: [
        // https://www.swift.org/sswg/incubated-packages.html

        // incubated packages
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.77.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.29.0"),
        .package(url: "https://github.com/apple/swift-nio-http2.git", from: "1.35.0"),
        .package(url: "https://github.com/apple/swift-nio-extras.git", from: "1.24.1"),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", from: "1.23.0"),
        .package(url: "https://github.com/apple/swift-nio-ssh.git", from: "0.9.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.2"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.5.0"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.23.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.24.0"),
        .package(url: "https://github.com/swift-server-community/APNSwift.git", from: "6.0.1"),
        .package(url: "https://github.com/apple/swift-statsd-client.git", from: "1.0.1"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.24.2"),
        .package(url: "https://github.com/xtremekforever/swift-crypto.git", branch: "patched-for-armv7"),
        .package(url: "https://github.com/soto-project/soto.git", from: "7.3.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.1.1"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.0"),

        // incubating packages
        .package(url: "https://github.com/swift-server/swift-prometheus.git", from: "2.0.0"),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", from: "3.3.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.6.2"),
        .package(url: "https://github.com/GraphQLSwift/GraphQL.git", from: "3.0.0"),
        .package(url: "https://github.com/GraphQLSwift/Graphiti.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-cassandra-client.git", from: "0.4.0"),
        .package(url: "https://github.com/vapor/sqlite-nio.git", from: "1.10.5"),
        .package(url: "https://github.com/apple/swift-service-context.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.1.2"),
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.6.0"),
        .package(url: "https://github.com/orlandos-nl/MongoKitten.git", from: "7.9.7"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.5.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-auth.git", from: "2.0.2"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-fluent.git", from: "2.0.0-beta.6"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-redis.git", from: "2.0.0-beta.8"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-websocket.git", from: "2.3.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-lambda.git", from: "2.0.0-rc.3"),
    ],
    targets: [
        .executableTarget(name: "hello-world"),
        .executableTarget(
            name: "sswg-incubated-packages",
            dependencies: [
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "NIOHTTP2", package: "swift-nio-http2"),
                .product(name: "NIOExtras", package: "swift-nio-extras"),
                .product(name: "NIOTransportServices", package: "swift-nio-transport-services"),
                .product(name: "NIOSSH", package: "swift-nio-ssh"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "APNS", package: "apnswift"),
                .product(name: "StatsdClient", package: "swift-statsd-client"),
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "SotoACM", package: "soto"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        .executableTarget(
            name: "sswg-incubating-packages",
            dependencies: [
                .product(name: "Prometheus", package: "swift-prometheus"),
                .product(name: "OpenAPIKit30", package: "openapikit"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "GraphQL", package: "graphql"),
                .product(name: "Graphiti", package: "graphiti"),
                .product(name: "CassandraClient", package: "swift-cassandra-client"),
                .product(name: "SQLiteNIO", package: "sqlite-nio"),
                .product(name: "ServiceContextModule", package: "swift-service-context"),
                .product(name: "Instrumentation", package: "swift-distributed-tracing"),
                .product(name: "MongoKitten", package: "mongokitten"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "HummingbirdFluent", package: "hummingbird-fluent"),
                .product(name: "HummingbirdRedis", package: "hummingbird-redis"),
                .product(name: "HummingbirdWebSocket", package: "hummingbird-websocket"),
                .product(name: "HummingbirdLambda", package: "hummingbird-lambda"),
            ]
        ),
    ]
)
