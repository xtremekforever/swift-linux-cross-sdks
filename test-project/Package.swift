// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "test-project",
    dependencies: [
        // https://www.swift.org/sswg/incubated-packages.html

        // graduated packages
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
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.10.0"),
        .package(url: "https://github.com/soto-project/soto.git", from: "7.3.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.1.1"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.0"),
    ],
    targets: [
        .executableTarget(name: "hello-world"),
        .executableTarget(
            name: "sswg-incubated-graduated",
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
    ]
)
