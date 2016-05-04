
public struct PackageInfo {
    public let name: String
    public let origin: String
    
    public let description: String
    public let version: String?
    
    public let sourceIndex: String

    public init(name: String, origin: String, description: String, version: String?, sourceIndex: String) {
    	self.name = name
    	self.origin = origin
        self.description = description
    	self.version = version
        self.sourceIndex = sourceIndex
    }
}

public struct Error: ErrorProtocol, CustomStringConvertible {
    
    public let description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
