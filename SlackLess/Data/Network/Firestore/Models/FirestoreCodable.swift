//
//  FirestoreCodable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation
import FirebaseFirestore

typealias JSON = [String: Any]

protocol FirestoreCodable: Codable {
    func encodeToJSON() throws -> JSON
    func decodeFromJSON(_ json: JSON) throws -> Self
}

extension FirestoreCodable {
    func encodeToJSON() throws -> JSON {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let jsonData = try? encoder.encode(self),
              var json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? JSON
        else { throw NetworkError.error("Couldn't encode to JSON") }
        
        json["createdAt"] = FieldValue.serverTimestamp()
        
        return json
    }
    
    func decodeFromJSON(_ json: JSON) throws -> Self {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
              let object = try? JSONDecoder().decode(Self.self, from: jsonData)
        else { throw NetworkError.error("Couldn't decode from JSON") }
        
        return object
    }
}
