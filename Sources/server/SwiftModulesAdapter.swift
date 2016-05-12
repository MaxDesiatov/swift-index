//
//  SwiftModulesAdapter.swift
//  swift-index
//
//  Created by Cory Alder on 5/12/16.
//
//

import shared
import HTTPSClient
import Vapor
import JSON

struct SwiftModulesAdapter: ThirdPartyIndexAdapter {
    
    var name: String = "Swift Modules"
    
    func search(_ query: String) throws -> [PackageInfo] {
        
        let raw = try self.fetch(query)
        let results = try self.convert(raw)
        return results
    }
    
    private func fetch(_ query: String) throws -> JSON {
        //https://swiftpkgs.ng.bluemix.net/api/search/jay?page=1&items=13
        
        let uri = URI(scheme: "https", host:"swiftmodules.com", port:443)
        let path = "/es/_search?q=\(query)"
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
        
        guard let array = dict["hits"]?.dictionary?["hits"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "\(self.name) server returned an invalid result array")
        }
        
        let results: [PackageInfo] = array
            .flatMap { $0.dictionary }
            .flatMap { rawObj in
                guard let obj = rawObj["_source"]?.dictionary else { return nil }
                guard let id = obj["packageName"]?.string else { return nil }
                guard let owner = obj["owner"]?.string else { return nil }
                guard let repo = obj["repo"]?.string else { return nil }
                guard let description = obj["summary"]?.string else { return nil }
                guard let version = obj["versions"]?.string else { return nil }
                let origin = "https://github.com/\(owner)/\(repo).git"
                return PackageInfo(name: id, origin: origin, description: description, version: version, sourceIndex: name)
        }
        return results
    }
}

