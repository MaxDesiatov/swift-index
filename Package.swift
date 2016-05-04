import PackageDescription

let package = Package(
    name: "swift-index",
    targets: [
    	Target(name: "shared"),
    	Target(name: "server", dependencies: [.Target(name: "shared")]),
    	Target(name: "client", dependencies: [.Target(name: "shared")])
    ],
    dependencies: [
                      
        // Server
    	.Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 7),
    	// .Package(url: "https://github.com/qutheory/vapor-zewo-server.git", majorVersion: 0),

        // HTTP utils
        .Package(url: "https://github.com/VeniceX/HTTPSClient.git", majorVersion: 0, minor: 6),

        // XML
        .Package(url: "https://github.com/Zewo/XML.git", majorVersion: 0, minor: 6),
    	
    	// CLI utils
    	.Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0, minor: 3)
    ]
)
