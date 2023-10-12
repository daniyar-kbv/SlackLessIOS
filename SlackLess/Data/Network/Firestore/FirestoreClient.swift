//
//  FirestoreClient.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa
import Moya

typealias FirestoreDocumentID = String

final class FirestoreClient<Endpoint: FirestoreEndpoint> {
    private let db = Firestore.firestore()
    
    func request<Response>(_ endpoint: Endpoint) -> Single<Response> {
        switch endpoint.method {
        case let .create(dto): return create(endpoint: endpoint, dto: dto)
        }
    }
    
    private func create<Response>(endpoint: FirestoreEndpoint, dto: FirestoreCodable) -> Single<Response> {
        return .create { [weak self] single in
            if let self = self {
                do {
                    var ref: DocumentReference? = nil
                    
                    ref = self.db.collection(endpoint.collectionName).addDocument(data: try dto.encodeToJSON()) { error in
                        if let error = error {
                            single(.error(error))
                        } else {
                            if let documentID = ref?.documentID as? Response {
                                single(.success(documentID))
                            } else {
                                single(.error(NetworkError.error("Document ID not found")))
                            }
                        }
                    }
                } catch {
                    single(.error(error))
                }
            } else {
                single(.error(NetworkError.error("Firestore client was deallocated")))
            }
                    
            return Disposables.create()
        }
    }
}
