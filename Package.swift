import PackageDescription

let package = Package(
    name: "swift-index",
    targets: [
    	Target(name: "shared"),
    	Target(name: "server", dependencies: [.Target(name: "shared")]),
    	Target(name: "client", dependencies: [.Target(name: "shared")])
    ],
    dependencies: [
    	.Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0),
    	.Package(url: "https://github.com/czechboy0/environment.git", majorVersion: 0),
    ]
)
