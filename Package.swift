import PackageDescription

let package = Package(
    name: "swift-index",
    targets: [
    	Target(name: "shared"),
    	Target(name: "server", dependencies: [.Target(name: "shared")]),
    	Target(name: "client", dependencies: [.Target(name: "shared")])
    ],
    dependencies: [
    	.Package(url: "https://github.com/qutheory/Vapor.git", majorVersion: 0),
    	.Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0),
    	.Package(url: "https://github.com/kylef/Requests.git", majorVersion: 0)
    ]
)
