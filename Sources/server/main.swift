
import Vapor
import Environment

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
    return Response(status: .OK, text: "See docs for available endpoints")
}

app.get("/v1/packages", handler: PackageController().handle)

// Lift-off
print("Starting server at port \(port)")
app.start(port: port)

