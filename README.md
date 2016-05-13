# swift-index

> Centralized package index for [SwiftPM](https://github.com/apple/swift-package-manager).

The idea behind `swift-index` is that even centralized indices can be decentralized. This repo is a prototype of a swift-index compatible server. All it does is translating other centralized search APIs (CocoaPods, Swift Package Catalog, SwiftModules) into a `swift-index` form. The idea is to create thin frontends to more package indices out there. Then, users would opt-in to particular centralized indices in their `Package.swift` manifest file (not yet implemented) and SwiftPM would only need to understand communication with a `swift-index` compatible server (whoever maintains it).

(This is a WIP prototype only created to start a conversation around a centralized package index for SwiftPM. You're welcome to comment and hack away.)

# Endpoints

This prototype server is running on `https://swift-index.herokuapp.com`, and so far only searching for packages with a specific keyword works, like

## `/v1/packages?q=keyword`

```
curl https://swift-index.herokuapp.com/v1/packages?q=json
```

returns 

```json
[
    {
        "description": "Swift implementation of JSON Web Token (JWT).",
        "name": "JSONWebToken.swift",
        "origin": "https://github.com/kylef/JSONWebToken.swift.git",
        "sourceIndex": "Swift Package Catalog",
        "version": ""
    },
    {
        "description": "JSON (RFC 7159)",
        "name": "JSON",
        "origin": "https://github.com/Zewo/JSON.git",
        "sourceIndex": "Swift Modules",
        "version": ""
    },
    {
        "description": "Magical Data Modelling Framework for JSON. Create rapidly powerful, atomic and smart data model classes.",
        "name": "JSONModel",
        "origin": "https://github.com/icanzilb/JSONModel.git",
        "sourceIndex": "CocoaPods",
        "version": "1.2.0"
    },
    ...
]
```

# Source Package Indices
- [Swift Package Catalog](https://swiftpkgs.ng.bluemix.net)
- [Swift Modules](https://swiftmodules.com)
- [CocoaPods](https://cocoapods.org)

Technology Stack
----------------
This server is written in Swift, powered by [Vapor](https://github.com/qutheory/vapor) and the prototype runs on Heroku.

:blue_heart: Code of Conduct
------------
Please note that this project is released with a [Contributor Code of Conduct](./CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

:gift_heart: Contributing
------------
Please create an issue with a description of your problem or a pull request with a fix. 

:v: License
-------
MIT

:alien: Author
------
Honza Dvorsky - http://honzadvorsky.com, [@czechboy0](http://twitter.com/czechboy0)
