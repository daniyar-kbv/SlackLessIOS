//
//  UnlockViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-27.
//

import Foundation
import PassKit
import RxCocoa
import RxSwift

protocol UnlockViewModelInput: AnyObject {
    func startPayment()
    func finish()
}

protocol UnlockViewModelOutput: AnyObject {
    var applePayStatus: BehaviorRelay<SLApplePayState> { get }
    var unlockSucceed: PublishRelay<Void> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var didFinish: PublishRelay<Void> { get }
}

protocol UnlockViewModel: AnyObject {
    var input: UnlockViewModelInput { get }
    var output: UnlockViewModelOutput { get }
}

final class UnlockViewModelImpl: UnlockViewModel, UnlockViewModelInput, UnlockViewModelOutput {
    var input: UnlockViewModelInput { self }
    var output: UnlockViewModelOutput { self }

    private let paymentService: PaymentService

    private let disposeBag = DisposeBag()

    init(paymentService: PaymentService) {
        self.paymentService = paymentService

        bindService()
    }

    //    Output
    lazy var applePayStatus: BehaviorRelay<SLApplePayState> = .init(value: makeApplePayStatus(from: paymentService.output.applePayStatus.value))
    let unlockSucceed: PublishRelay<Void> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    let didFinish: PublishRelay<Void> = .init()

    //    Input
    func startPayment() {
        paymentService.input.startPayment()
    }

    func finish() {
        didFinish.accept(())
    }
}

extension UnlockViewModelImpl {
    private func bindService() {
        paymentService.output.applePayStatus
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                applePayStatus.accept(makeApplePayStatus(from: $0))
            })
            .disposed(by: disposeBag)

        paymentService.output.unlockSucceed
            .bind(to: unlockSucceed)
            .disposed(by: disposeBag)

        paymentService.output.errorOccured
            .subscribe(onNext: { [weak self] in
                self?.errorOccured.accept($0)
            })
            .disposed(by: disposeBag)
    }

    private func makeApplePayStatus(from status: (canMakePayments: Bool, canSetupCards: Bool)) -> SLApplePayState {
        switch status {
        case (true, _): return .pay
        case (_, true): return .setUp
        default: return .failure
        }
    }
}
