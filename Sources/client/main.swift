
import shared
import HTTPSClient
import JSON

do {
    let args = Array(Process.arguments.dropFirst())
    guard let query = args.first else { throw Error("Must pass a search string as first argument") }
    
    print("Searching \"\(query)\"")
    
    let uri = URI(scheme: "https", host:"swift-index.herokuapp.com", port:443)
    let path = "/v1/packages?q=\(query)"
    let client = try Client(uri: uri)
    var response : Response = try client.get(path)
    guard response.status == .ok else {
        throw Error("Failed to contact the Swift Index server")
    }
    let data = try response.body.becomeBuffer()
    let json = try JSONParser().parse(data: data)
    
    func packageFromJson(_ json: JSON) -> PackageInfo {
        return PackageInfo(name: json["name"]!.string!, origin: json["origin"]!.string!, description: json["description"]!.string!, version: json["version"]!.string!, sourceIndex: json["sourceIndex"]!.string!)
    }
    
    guard let results = json.array?.map(packageFromJson) else { throw Error("Received malformed data") }
    
    print("Received \(results.count) results:")
    results.forEach {
        print(" -> \($0.name) (\($0.origin)) [source: \($0.sourceIndex)]")
    }
    
} catch {
    print(error)
}

