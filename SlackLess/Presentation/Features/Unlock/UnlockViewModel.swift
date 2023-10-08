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
    func shortUnlock()
    func finish()
}

protocol UnlockViewModelOutput: AnyObject {
    var applePayStatus: BehaviorRelay<SLApplePayState> { get }
    var unlockSucceed: PublishRelay<SLLockUpdateType> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var didFinish: PublishRelay<Void> { get }
    
    func getSettingsViewModel() -> SLSettingsViewModel
    func getSettingsValues() -> (unlockPrice: Double?, unlockTime: Double)
}

protocol UnlockViewModel: AnyObject {
    var input: UnlockViewModelInput { get }
    var output: UnlockViewModelOutput { get }
}

final class UnlockViewModelImpl: UnlockViewModel, UnlockViewModelInput, UnlockViewModelOutput {
    var input: UnlockViewModelInput { self }
    var output: UnlockViewModelOutput { self }

    private let appSettingsService: AppSettingsService
    private let paymentService: PaymentService
    private let lockService: LockService

    private let disposeBag = DisposeBag()
    private lazy var settingsViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .display,
                                                                                      appSettingsService: appSettingsService,
                                                                                      pushNotificationsService: nil)

    init(appSettingsService: AppSettingsService,
         paymentService: PaymentService,
         lockService: LockService) {
        self.appSettingsService = appSettingsService
        self.paymentService = paymentService
        self.lockService = lockService

        bindServices()
    }

    //    Output
    lazy var applePayStatus: BehaviorRelay<SLApplePayState> = .init(value: makeApplePayStatus(from: paymentService.output.applePayStatus.value))
    let unlockSucceed: PublishRelay<SLLockUpdateType> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    let didFinish: PublishRelay<Void> = .init()
    
    func getSettingsViewModel() -> SLSettingsViewModel {
        settingsViewModel
    }
    
    func getSettingsValues() -> (unlockPrice: Double?, unlockTime: Double) {
        return (appSettingsService.output.getUnlockPrice(), Constants.Settings.unlockTime)
    }

    //    Input
    func startPayment() {
        paymentService.input.startPayment()
    }
    
    func shortUnlock() {
        lockService.input.updateLock(type: .shortUnlock)
    }

    func finish() {
        didFinish.accept(())
    }
}

extension UnlockViewModelImpl {
    private func bindServices() {
        paymentService.output.applePayStatus
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                applePayStatus.accept(makeApplePayStatus(from: $0))
            })
            .disposed(by: disposeBag)

        paymentService.output.unlockSucceed
            .subscribe(onNext: { [weak self] in
                self?.unlockSucceed.accept(.longUnlock)
            })
            .disposed(by: disposeBag)

        paymentService.output.errorOccured
            .subscribe(onNext: { [weak self] in
                self?.errorOccured.accept($0)
            })
            .disposed(by: disposeBag)
        
        lockService.output.didUpdateLock
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .shortUnlock: self?.unlockSucceed.accept($0)
                default: break
                }
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
