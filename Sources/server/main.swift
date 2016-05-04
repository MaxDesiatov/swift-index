
import Vapor
import Environment
import HTTPSClient

// Prep
let env = Environment()
let app = Application()

// Figure out config
var port: Int = 8080
if let envPort = env.getVar("PORT"), let envPortInt = Int(envPort) {
    port = envPortInt
}

// Route

app.get("/") { _ in
    return Response(status: .ok, html: "<html><body><h1>Docs at <a href=\"https://github.com/czechboy0/swift-index#swift-index\">https://github.com/czechboy0/swift-index</a></h1></body></html>")
}

app.get("/v1/packages", handler: PackageController().handle)

// Lift-off
print("Starting server at port \(port)")
app.start(port: port)

