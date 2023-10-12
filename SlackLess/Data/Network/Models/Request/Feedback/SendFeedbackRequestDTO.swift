//
//  SendFeedbackRequestDTO.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation
import FirebaseFirestore

struct SendFeedbackRequestDTO: FirestoreCodable {
    let body: String
    let email: String?
}
