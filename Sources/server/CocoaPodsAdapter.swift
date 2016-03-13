//
//  CocoaPodsAdapter.swift
//  swift-index
//
//  Created by Honza Dvorsky on 3/13/16.
//
//

import shared
import Requests
import Vapor

struct CocoaPodsAdapter: ThirdPartyIndexAdapter {
    
    var name: String = "CocoaPods"
    
    func search(query: String) throws -> [PackageInfo] {
        
        let raw = try self.fetch(query)
        let results = try self.convert(raw)
        return results
    }
    
    private func fetch(query: String) throws -> Json {
        
        let url = "http://search.cocoapods.org/api/v1/pods.flat.hash.json?query=\(query)&ids=10&offset=0&sort=quality"
        let response = try request(method: "GET", url: url)
        guard response.status == .Ok else {
            throw Abort.Custom(status: .Error, message: "Failed to contact CocoaPods server")
        }
        guard var body = response.body else {
            throw Abort.Custom(status: .Error, message: "CocoaPods server returned no data")
        }
        var buffer = [UInt8]()
        var newData: [UInt8]? = nil
        repeat {
            newData = body.next()
            buffer.appendContentsOf(newData ?? [])
        } while newData != nil
        
        //parse json body
        let json = try Json.deserialize(buffer)
        return json
    }
    
    private func convert(raw: Json) throws -> [PackageInfo] {
        
        guard let array = raw.arrayValue else {
            throw Abort.Custom(status: .Error, message: "CocoaPods server returned an invalid array")
        }
        let indexName = self.name

        let preprocessed: [(String, String, String)] = array
            .flatMap { $0.objectValue }
            .flatMap { obj in
                guard let id = obj["id"]?.stringValue else { return nil }
                guard let source = obj["source"]?.objectValue else { return nil }
                guard let origin = source["git"]?.stringValue else { return nil }
                guard let version = source["tag"]?.stringValue else { return nil }
                return (id, origin, version)
            }
        let results = preprocessed.map {
            PackageInfo(name: $0.0, origin: $0.1, version: $0.2, sourceIndex: indexName)
        }
        return results
    }
}

