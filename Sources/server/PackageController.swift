//
//  PackageController.swift
//  swift-index
//
//  Created by Honza Dvorsky on 3/13/16.
//
//

import Vapor
import shared

class PackageController: Controller {
    
    required init() { }
    
    func handle(request: Request) throws -> ResponseConvertible {
        
        //fetch results
        let query = request.data.query["q"]
        let results = try self.packages(query)
        
        //convert back to json
        let jsonResults = Json(try results.map { try $0.jsonRepresentation() })
        let queryInfo = query != nil ? "for query \"\(query!)\"" : ""
        Log.verbose("Returning \(results.count) results \(queryInfo)")
        return try Response(status: .OK, json: jsonResults)
    }
    
    func packages(query: String? = nil) throws -> [PackageInfo] {
        return [
            PackageInfo(name: "Alamofire", origin: "https://github.com/Alamofire/Alamofire.git", version: "3.0.0"),
            PackageInfo(name: "ReactiveCocoa", origin: "https://github.com/ReactiveCocoa/ReactiveCocoa.git", version: "4.0.1")
        ]
    }
    
}

extension PackageInfo {
    func jsonRepresentation() throws -> Json {
        return try Json(
            [
                "name": name,
                "origin": origin,
                "version": version
            ]
        )
    }
}
