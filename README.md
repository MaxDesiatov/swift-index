# swift-index

> Centralized package index for [SwiftPM](https://github.com/apple/swift-package-manager).

The idea behind `swift-index` is that even centralized indices can be decentralized. This repo provides the necessary code to create a swift-index compatible server, which can in turn just be a proxy to another index (e.g. CocoaPods). Then, users will opt-in to particular centralized indices in their `Package.swift` manifest file (not yet implemented).

# Endpoints

This prototype server is running on `https://swift-index.herokuapp.com`, and so far only searching for packages with a specific keyword works, like

## `/v1/packages?q=keyword`

```
curl https://swift-index.herokuapp.com/v1/packages\?q\=alamofire
```

returns 

```json
[
    {
        "name": "Alamofire",
        "origin": "https://github.com/Alamofire/Alamofire.git",
        "sourceIndex": "CocoaPods",
        "version": "3.2.1"
    },
    {
        "name": "AlamofireImage",
        "origin": "https://github.com/Alamofire/AlamofireImage.git",
        "sourceIndex": "CocoaPods",
        "version": "2.3.1"
    },
    {
        "name": "AlamofireDomain",
        "origin": "https://github.com/tonyli508/AlamofireDomain.git",
        "sourceIndex": "CocoaPods",
        "version": "2.1.0"
    },
    ...
]
```

At the moment, only `CocoaPodsAdapter` is implemented, so all results are coming from CocoaPods. The plan is to allow for aggregating packages from multiple sources.

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
