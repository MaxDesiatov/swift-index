//
//  CocoaPodsAdapter.swift
//  swift-index
//
//  Created by Honza Dvorsky on 3/13/16.
//
//

import shared
import HTTPSClient
import Vapor
import JSON

struct CocoaPodsAdapter: ThirdPartyIndexAdapter {
    
    var name: String = "CocoaPods"
    
    func search(_ query: String) throws -> [PackageInfo] {
        
        let raw = try self.fetch(query)
        let results = try self.convert(raw)
        return results
    }
    
    private func fetch(_ query: String) throws -> JSON {
        
        //FIXME: We need to filter only SwiftPM-compatible Pods, hopefully
        //this will help: https://github.com/CocoaPods/search.cocoapods.org/issues/103
        
        let uri = URI(scheme: "https", host:"search.cocoapods.org", port:443)
        let path = "/api/v1/pods.flat.hash.json?query=\(query)&ids=5&offset=0&sort=quality"
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
        
        guard let array = raw.array else {
            throw Abort.custom(status: .internalServerError, message: "CocoaPods server returned an invalid array")
        }
        let indexName = self.name

        let results: [PackageInfo] = array
            .flatMap { $0.dictionary }
            .flatMap { obj in
                guard let id = obj["id"]?.string else { return nil }
                guard let source = obj["source"]?.dictionary else { return nil }
                guard let origin = source["git"]?.string else { return nil }
                guard let description = obj["summary"]?.string else { return nil }
                guard let version = source["tag"]?.string else { return nil }
                return PackageInfo(name: id, origin: origin, description: description, version: version, sourceIndex: indexName)
            }
        return results
    }
}

