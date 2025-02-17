//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct FormBody: HTTPBody {
    
    public var isEmpty: Bool { urlQueryItems.isEmpty }
    
    public let additionalHeaders: [String : String] = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    
    private let urlQueryItems: [URLQueryItem]
    
    public init(urlQueryItems: [URLQueryItem]) {
        self.urlQueryItems = urlQueryItems
    }
    
    public init(urlQueryItems: [String: String]) {
        self.urlQueryItems = urlQueryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    public func encode() throws -> Data {
        let pieces = urlQueryItems.map(self.urlEncode)
        let bodyString = pieces.joined(separator: "&")
        return Data(bodyString.utf8)
    }

    private func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }
    
    private func urlEncode(_ value: String) -> String{
        let allowedCharacters = CharacterSet.alphanumerics
        return value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
}
