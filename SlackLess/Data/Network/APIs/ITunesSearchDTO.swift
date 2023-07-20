//
//  ITunesResponseDTO.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation

struct ITunesSearchDTO: Decodable {
    let results: [Result]
    
    struct Result: Decodable {
        let iconURL: String?
        
        enum CodingKeys: String, CodingKey {
            case iconURL = "artworkUrl100"
        }
    }
}
