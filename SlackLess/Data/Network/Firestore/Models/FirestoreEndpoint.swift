//
//  FirestoreEndpoint.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation

protocol FirestoreEndpoint {
    var method: FirestoreEndpointMethod { get }
    var collectionName: String { get }
}
