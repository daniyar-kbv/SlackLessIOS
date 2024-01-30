//
//  IAPManager.swift
//  IAPManager
//
//  Created by Sergey Zhuravel on 12/30/21.
//

import UIKit
import StoreKit

//  TODO: Refactor with protocol

public typealias ProductId = String

class IAPManager: NSObject {
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    fileprivate var pendingFetchProduct: String!
    var fetchAvailableProductsBlock : (([SKProduct]) -> Void)? = nil
    var purchaseStatusBlock: ((IAPManagerAlertType) -> Void)?
    var receipt: IAPReceipt?
    
    public var purchasedProductIdentifiers = Set<ProductId>()
    
    override init() {
        super.init()
        
        fetchAvailableProducts()
        processReceipt()
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    private func fetchAvailableProducts(){
        productsRequest.cancel()

        let productIdentifiers = NSSet(objects: Constants.IAP.Products.oneCredit.rawValue)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func purchaseMyProduct(productIdentifier: String, quantity: Int = 1) {
        if iapProducts.isEmpty {
            pendingFetchProduct = productIdentifier
            fetchAvailableProducts()
            return
        }
        
        if canMakePurchases() {
            for product in iapProducts {
                if product.productIdentifier == productIdentifier {
                    let payment = SKMutablePayment(product: product)
                    payment.quantity = quantity
                    SKPaymentQueue.default().add(self)
                    SKPaymentQueue.default().add(payment)
                }
            }
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPManager: SKProductsRequestDelegate {
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
//        TODO: Add proper logging
        print("Loaded list of products:", response.products.map({ $0.productIdentifier }))
        print("Loaded list of invalid products:", response.invalidProductIdentifiers)
        if response.products.count > 0 {
            iapProducts = response.products
            fetchAvailableProductsBlock?(response.products)
            
            if let product = pendingFetchProduct {
                purchaseMyProduct(productIdentifier: product)
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error load products", error)
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restore finished")
        purchaseStatusBlock?(.restored)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Restore failed with error: \(error)")
        purchaseStatusBlock?(.failed)
    }
    
    // MARK: - IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Updated transactions: \(transactions)")
        for transaction: AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    if let transaction = transaction as? SKPaymentTransaction {
                        purchaseStatusBlock?(.purchased)
                        SKPaymentQueue.default().finishTransaction(transaction)
                        
                        if IAPConstants.isLocalValidateReceipt {
                            processReceipt()
                        } else {
                            receiptAppStoreValidation()
                        }
                    }
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.failed)
                case .restored:
                    if let transaction = transaction as? SKPaymentTransaction {
                        SKPaymentQueue.default().finishTransaction(transaction)
                    }
                default: break
                }
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        if canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            return true
        } else {
            return false
        }
    }
}

extension IAPManager {
    
    public func processReceipt() {
        print("receiptValidationStarted")
        
        receipt = IAPReceipt()
        
        guard let receipt = receipt,
              receipt.isReachable,
              receipt.load(),
//              FIXME: Fix receipt signing validation
//              receipt.validateSigning(),
              receipt.read(),
              receipt.validate() else {
            
            print("receiptProcessingFailure")
            return
        }
        
        createValidatedPurchasedProductIds(receipt: receipt)
        print("receiptProcessingSuccess")
        return
    }
    
    
    private func createValidatedPurchasedProductIds(receipt: IAPReceipt) {
        if purchasedProductIdentifiers == receipt.validatedPurchasedProductIdentifiers {
            print("purchasedProductsValidatedAgainstReceipt")
            return
        }
        
        IAPPersistence.resetPurchasedProductIds(from: purchasedProductIdentifiers, to: receipt.validatedPurchasedProductIdentifiers)
        purchasedProductIdentifiers = receipt.validatedPurchasedProductIdentifiers
        print("purchasedProductsValidatedAgainstReceipt")
    }
}

extension IAPManager {
    var validationURLString: String {
        if Constants.Settings.environmentType != .production { return "https://sandbox.itunes.apple.com/verifyReceipt" }
        return "https://buy.itunes.apple.com/verifyReceipt"
    }
    
    // Status code returned by remote server
    public enum ReceiptStatus: Int {
        // Not decodable status
        case unknown = -2
        // No status returned
        case none = -1
        // valid statu
        case valid = 0
        // The App Store could not read the JSON object you provided.
        case jsonNotReadable = 21000
        // The data in the receipt-data property was malformed or missing.
        case malformedOrMissingData = 21002
        // The receipt could not be authenticated.
        case receiptCouldNotBeAuthenticated = 21003
        // The shared secret you provided does not match the shared secret on file for your account.
        case secretNotMatching = 21004
        // The receipt server is not currently available.
        case receiptServerUnavailable = 21005
        // This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.
        case subscriptionExpired = 21006
        //  This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead.
        case testReceipt = 21007
        // This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead.
        case productionEnvironment = 21008

        var isValid: Bool { return self == .valid}
    }
    
    func receiptAppStoreValidation() {
        
        let SUBSCRIPTION_SECRET = "YOUR_SHARED_SECRET"
        guard let receiptPath = Bundle.main.appStoreReceiptURL?.path else { return }
        if FileManager.default.fileExists(atPath: receiptPath) {
            var receiptData: NSData?
            do {
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            } catch {
                print("ERROR receiptValidation: \(error.localizedDescription)")
            }
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            let requestDictionary = ["receipt-data": base64encodedReceipt!, "password": SUBSCRIPTION_SECRET]
            
            guard JSONSerialization.isValidJSONObject(requestDictionary) else { print("requestDictionary is not valid JSON"); return }
            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
                guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
                let session = URLSession(configuration: URLSessionConfiguration.default)
                var request = URLRequest(url: validationURL)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                let task = session.uploadTask(with: request, from: requestData) { data, _, error in
                    if let data = data, error == nil {
                        do {
                            let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as! NSDictionary
                            
                            if appReceiptJSON["status"] != nil {
                                if let status = appReceiptJSON["status"] as? Int {
                                    let receiptStatus = ReceiptStatus(rawValue: status) ?? ReceiptStatus.unknown
                                    
                                    if receiptStatus.isValid {
                                        var latestReceipt = ""
                                        if appReceiptJSON["latest_receipt"] != nil {
                                            latestReceipt = appReceiptJSON["latest_receipt"] as! String
                                            //here you can parse the receipt and determine if there is an active subscription or not
                                            
                                        }
                                    } else {
                                        print("receipt not valid")
                                    }
                                }
                            }
                        } catch let error as NSError {
                            print("json serialization failed with error: \(error.localizedDescription)")
                        }
                    } else {
                        print("the upload task returned an error: \(String(describing: error))")
                    }
                }
                task.resume()
            } catch let error as NSError {
                print("json serialization failed with error: \(error)")
            }
        }
    }
}
