
import Vapor
import Environment
import HTTPSClient

do {
    
    let uri = URI(host:"https://fastlane.tools", port:443)
    let path = "/"
    
    let client = try Client(uri: uri)
    var response: Response = try client.get(path)
    print("\(response.status)")
//    let buffer = try response.body.becomeBuffer()
    //print("\(buffer)")
} catch let error {
    print("\(error)")
}


//// Prep
//let env = Environment()
//let app = Application()
//
//// Figure out config
//var port: Int = 8080
//if let envPort = env.getVar("PORT"), let envPortInt = Int(envPort) {
//    port = envPortInt
//}
//
//// Route
//
//app.get("/") { _ in
//    return Response(status: .ok, text: "See docs: https://github.com/czechboy0/swift-index")
//}
//
//app.get("/v1/packages", handler: PackageController().handle)
//
//// Lift-off
//print("Starting server at port \(port)")
//app.start(port: port)

