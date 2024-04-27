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
    let os: String?
    let device: String
    let systemVersion: String?
    let appVersion: String
    let buildNumber: String
}
