//
//  ThirdPartyIndexAdapter.swift
//  swift-index
//
//  Created by Honza Dvorsky on 3/13/16.
//
//

import shared

protocol ThirdPartyIndexAdapter {
    var name: String { get }
    func search(query: String) throws -> [PackageInfo]
}
