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

struct CocoaPodsAdapter: ThirdPartyIndexAdapter {
    
    var name: String = "CocoaPods"
    
    func search(_ query: String) throws -> [PackageInfo] {
        
        let raw = try self.fetch(query)
        let results = try self.convert(raw)
        return results
    }
    
    private func fetch(_ query: String) throws -> Json {
        
        //FIXME: We need to filter only SwiftPM-compatible Pods, hopefully
        //this will help: https://github.com/CocoaPods/search.cocoapods.org/issues/103
        
        do {
            
//            let uri = URI(host:"search.cocoapods.org", port:443)
//            let path = "/api/v1/pods.flat.hash.json?query=\(query)&ids=10&offset=0&sort=quality"
//            let uri = URI(host:"slack.com", port:443)
//            let path = "/api/api.test?token=xoxp-15501035636-31291610038-36556570676-fde9952e71"
            let uri = URI(host:"honzadvorsky.com", port:443)
            let path = "/"
            
            
            let client = try Client(uri: uri)
            var response : Response = try client.get(path)
            print("\(response)")
            let buffer = try response.body.becomeBuffer()
            print("\(buffer)")
        } catch let error {
            print("\(error)")
        }

        
//        let client = try! Client(uri: "https://www.google.cz:443")
//        let request = Request(path: "/?gfe_rd=cr&ei=LNofV6iuG-ak8wfs5JYo")
//        
//        let response = try! client.respond(to: request)
//        print(response)
        
//        let response = try request(method: "GET", url: url)
//        guard response.status == .Ok else {
//            throw Abort.Custom(status: .Error, message: "Failed to contact CocoaPods server")
//        }
//        guard var body = response.body else {
//            throw Abort.Custom(status: .Error, message: "CocoaPods server returned no data")
//        }
//        var buffer = [UInt8]()
//        var newData: [UInt8]? = nil
//        repeat {
//            newData = body.next()
//            buffer.appendContentsOf(newData ?? [])
//        } while newData != nil
//        
//        //parse json body
//        let json = try Json.deserialize(buffer)
//        let json = try Json.deserialize([])
//        return json
        return Json.bool(false)
    }
    
    private func convert(_ raw: Json) throws -> [PackageInfo] {
        
//        guard let array = raw.arrayValue else {
//            throw Abort.Custom(status: .Error, message: "CocoaPods server returned an invalid array")
//        }
//        let indexName = self.name
//
//        let preprocessed: [(String, String, String)] = array
//            .flatMap { $0.objectValue }
//            .flatMap { obj in
//                guard let id = obj["id"]?.stringValue else { return nil }
//                guard let source = obj["source"]?.objectValue else { return nil }
//                guard let origin = source["git"]?.stringValue else { return nil }
//                guard let version = source["tag"]?.stringValue else { return nil }
//                return (id, origin, version)
//            }
//        let results = preprocessed.map {
//            PackageInfo(name: $0.0, origin: $0.1, version: $0.2, sourceIndex: indexName)
//        }
//        return results
        return []
    }
}

