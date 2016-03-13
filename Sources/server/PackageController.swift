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
    
    let thirdPartyAdapters: [ThirdPartyIndexAdapter]
    required init() {
        self.thirdPartyAdapters = [
            CocoaPodsAdapter()
        ]
    }
    
    func handle(request: Request) throws -> ResponseConvertible {
        
        //fetch results
        guard let query = request.data.query["q"] where !query.isEmpty else {
            throw Abort.Custom(status: .BadRequest, message: "A query must be provided \"/packages?q=name\"")
        }
        let results = try self.packages(query)
        
        //convert back to json
        let jsonResults = Json(try results.map { try $0.jsonRepresentation() })
        let queryInfo = "for query \"\(query)\""
        Log.verbose("Returning \(results.count) results \(queryInfo)")
        return try Response(status: .OK, json: jsonResults)
    }
    
    func packages(query: String) throws -> [PackageInfo] {
        
        //query each index for packages matching this query
        let raw = try self.thirdPartyAdapters.flatMap { try $0.search(query) }
        
        //de-duplicate packages coming from multiple
        //indices. origin git url should be enough to recognize duplicates.
        var origins = Set<String>()
        let deduplicated = raw.filter {
            if origins.contains($0.origin) { return false }
            origins.insert($0.origin)
            return true
        }
        return deduplicated
    }
    
}

extension PackageInfo {
    func jsonRepresentation() throws -> Json {
        return try Json(
            [
                "name": name,
                "origin": origin,
                "version": version,
                "sourceIndex": sourceIndex
            ]
        )
    }
}
