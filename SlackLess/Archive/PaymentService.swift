////
////  PaymentService.swift
////  SlackLess
////
////  Created by Daniyar Kurmanbayev on 2023-09-27.
////
//
//import Foundation
//import PassKit
//import RxCocoa
//import RxSwift
//
//protocol PaymentServiceInput: AnyObject {
//    func startPayment()
//}
//
//protocol PaymentServiceOutput: AnyObject {
//    var applePayStatus: BehaviorRelay<(canMakePayments: Bool, canSetupCards: Bool)> { get }
//    var unlockSucceed: PublishRelay<Void> { get }
//    var errorOccured: PublishRelay<DomainError> { get }
//}
//
//protocol PaymentService: AnyObject {
//    var input: PaymentServiceInput { get }
//    var output: PaymentServiceOutput { get }
//}
//
//final class PaymentServiceImpl: NSObject, PaymentService, PaymentServiceInput, PaymentServiceOutput {
//    var input: PaymentServiceInput { self }
//    var output: PaymentServiceOutput { self }
//
//    private let eventManager: EventManager
//    private lazy var disposeBag = DisposeBag()
//    private let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .JCB, .amex, .cartesBancaires, .chinaUnionPay, .discover, .eftpos, .electron, .idCredit, .interac, .maestro, .privateLabel, .quicPay, .suica, .vPay]
//    private let merchantCapabilities: PKMerchantCapability = .capability3DS
//
//    var paymentStatus: PKPaymentAuthorizationStatus = .failure
//
//    init(eventManager: EventManager) {
//        self.eventManager = eventManager
//
//        applePayStatus = .init(value: (
//            canMakePayments: PKPaymentAuthorizationController.canMakePayments(),
//            canSetupCards: PKPaymentAuthorizationController.canMakePayments(
//                usingNetworks: supportedNetworks,
//                capabilities: merchantCapabilities
//            )
//        )
//        )
//
//        super.init()
//
//        bindEventManager()
//    }
//
//    //    Output
//    let applePayStatus: BehaviorRelay<(canMakePayments: Bool, canSetupCards: Bool)>
//    let unlockSucceed: PublishRelay<Void> = .init()
//    let errorOccured: PublishRelay<DomainError> = .init()
//
//    //    Input
//    func startPayment() {
//        let request = PKPaymentRequest()
//        request.merchantIdentifier = Constants.Payment.applePayMerchantId
//        request.supportedNetworks = supportedNetworks
//        request.merchantCapabilities = merchantCapabilities
//        request.countryCode = "US"
//        request.currencyCode = "USD"
//        request.paymentSummaryItems = [
//            .init(label: SLTexts.Unlock.Payment.itemLabel.localized(), amount: 1),
//            .init(label: SLTexts.Unlock.Payment.taxLabel.localized(), amount: 1, type: .pending),
//            .init(label: SLTexts.Unlock.Payment.totalLabel.localized(), amount: 1, type: .final)
//        ]
//
//        let applePayController = PKPaymentAuthorizationController(paymentRequest: request)
//        applePayController.delegate = self
//        applePayController.present(completion: { [weak self] presented in
//            if presented {
//                debugPrint("Presented payment controller")
//            } else {
//                debugPrint("Failed to present payment controller")
//                self?.errorOccured.accept(DomainError.general)
//            }
//        })
//    }
//}
//
//extension PaymentServiceImpl {
//    private func bindEventManager() {
//        eventManager.subscribe(to: .updateLockSucceed, disposeBag: disposeBag) { [weak self] type in
//            switch type.value as? SLDeviceActivityEventType {
//            case .lock: self?.unlockSucceed.accept(())
//            default: break
//            }
//        }
//
//        eventManager.subscribe(to: .updateLockFailed, disposeBag: disposeBag) { [weak self] in
//            guard let error = $0.value as? DomainError else { return }
//            self?.errorOccured.accept(error)
//        }
//    }
//}
//
//extension PaymentServiceImpl: PKPaymentAuthorizationControllerDelegate {
//    func paymentAuthorizationController(_: PKPaymentAuthorizationController, didAuthorizePayment _: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        // Perform basic validation on the provided contact information.
//        var errors = [Error]()
//        var status = PKPaymentAuthorizationStatus.success
//
//        // Send the payment token to your server or payment provider to process here.
//        // Once processed, return an appropriate status in the completion handler (success, failure, and so on).
//
//        paymentStatus = status
//        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
//    }
//
//    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
//        controller.dismiss { [weak self] in
//            guard self?.paymentStatus == .success
//                    || Constants.Settings.appMode == .debug
//            else { return }
//
//            DispatchQueue.main.async {
//                self?.eventManager.send(event: .init(type: .paymentFinished))
//            }
//        }
//    }
//}
