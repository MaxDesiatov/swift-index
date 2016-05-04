
public struct PackageInfo {
    public let name: String
    public let origin: String
    public let version: String?
    
    public let sourceIndex: String

    public init(name: String, origin: String, version: String?, sourceIndex: String) {
    	self.name = name
    	self.origin = origin
    	self.version = version
        self.sourceIndex = sourceIndex
    }
}

