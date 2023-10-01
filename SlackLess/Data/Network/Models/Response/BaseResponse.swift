//
//  BaseResponse.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

// TODO: Refactor

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let data: T?
    let error: ErrorResponseDTO?
}
