//
//  SwiftPackageCatalogAdapter.swift
//  swift-index
//
//  Created by Honza Dvorsky on 5/4/16.
//
//

import shared
import HTTPSClient
import Vapor
import JSON

struct SwiftPackageCatalogAdapter: ThirdPartyIndexAdapter {
    
    var name: String = "Swift Package Catalog"
    
    func search(_ query: String) throws -> [PackageInfo] {
        
        let raw = try self.fetch(query)
        let results = try self.convert(raw)
        return results
    }
    
    private func fetch(_ query: String) throws -> JSON {
        //https://swiftpkgs.ng.bluemix.net/api/search/jay?page=1&items=13
        
        let uri = URI(scheme: "https", host:"swiftpkgs.ng.bluemix.net", port:443)
        let path = "/api/search/\(query)?page=1&items=5"
        let client = try Client(uri: uri)
        var response : Response = try client.get(path)
        guard response.status == .ok else {
            throw Abort.custom(status: .internalServerError, message: "Failed to contact CocoaPods server")
        }
        let data = try response.body.becomeBuffer()
        let json = try JSONParser().parse(data: data)
        return json
    }
    
    private func convert(_ raw: JSON) throws -> [PackageInfo] {
        
        guard let dict = raw.dictionary else {
            throw Abort.custom(status: .internalServerError, message: "\(self.name) server returned an invalid result")
        }
        let indexName = self.name
        
        guard let array = dict["data"]?.dictionary?["hits"]?.dictionary?["hits"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "\(self.name) server returned an invalid result array")
        }
        
        let results: [PackageInfo] = array
            .flatMap { $0.dictionary }
            .flatMap { rawObj in
                guard let obj = rawObj["_source"]?.dictionary else { return nil }
                guard let id = obj["package_name"]?.string else { return nil }
                guard let origin = obj["git_clone_url"]?.string else { return nil }
                guard let description = obj["description"]?.string else { return nil }
                //No version? :/
                return PackageInfo(name: id, origin: origin, description: description, version: nil, sourceIndex: name)
        }
        return results
    }
}

