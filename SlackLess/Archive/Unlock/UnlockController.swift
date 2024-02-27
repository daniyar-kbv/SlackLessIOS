////
////  UnlockController.swift
////  SlackLess
////
////  Created by Daniyar Kurmanbayev on 2023-09-29.
////
//
//import Foundation
//import PassKit
//import RxCocoa
//import RxSwift
//import UIKit
//
//final class UnlockController: UIViewController {
//    private let viewModel: UnlockViewModel
//
//    private let disposeBag = DisposeBag()
//    private lazy var contentView = UnlockView()
//    private lazy var settingsController = SLSettingsController(viewModel: viewModel.output.getSettingsViewModel())
//
//    init(viewModel: UnlockViewModel) {
//        self.viewModel = viewModel
//
//        super.init(nibName: .none, bundle: .none)
//    }
//
//    @available(*, unavailable)
//    required init?(coder _: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        viewModel.input.finish()
//    }
//
//    override func loadView() {
//        super.loadView()
//
//        view = contentView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureView()
//        bindView()
//        bindViewModel()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        add(controller: settingsController, to: contentView.settingsView)
//    }
//
//    private func configureView() {
//        contentView.set(title: SLTexts.Unlock.title.localized())
//        
//        let settingsValues = viewModel.output.getSettingsValues()
//        if let unlockPrice = settingsValues.unlockPrice {
//            contentView.subtitleLabel.text = SLTexts.Unlock.subtitle.localized(String(Int(unlockPrice)), String(settingsValues.unlockTime.get(component: .minutes)))
//        }
//        
////        FIXME: Localize "Pay"
//        setUpTerms(label: &contentView.termsLabel,
//                   accentColor: SLColors.accent1.getColor(),
//                   clickElementName: "Pay",
//                   twoLined: false)
//    }
//    
//    private func bindView() {
//        contentView.bottomButton.rx.tap
//            .subscribe(onNext: viewModel.input.shortUnlock)
//            .disposed(by: disposeBag)
//    }
//
//    private func bindViewModel() {
//        viewModel.output.applePayStatus
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                contentView.setUpApplePayButton(for: $0)?
//                    .rx.tap
//                    .subscribe(onNext: handleApplePayButtonTap)
//                    .disposed(by: disposeBag)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.output.unlockSucceed
//            .subscribe(onNext: { [weak self] _ in
//                self?.showAlert(title: SLTexts.Unlock.Alert.Success.title.localized(),
//                                message: SLTexts.Unlock.Alert.Success.message.localized(String(SLLocker.shared.unlockTime.get(component: .minutes))),
//                                submitTitle: SLTexts.Alert.Action.defaultTitle.localized()) {
//                    self?.dismiss(animated: true)
//                }
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.output.errorOccured
//            .subscribe(onNext: { [weak self] in
//                self?.showError($0)
//            })
//            .disposed(by: disposeBag)
//    }
//}
//
//extension UnlockController {
//    private func handleApplePayButtonTap() {
//        switch viewModel.output.applePayStatus.value {
//        case .pay:
//            viewModel.input.startPayment()
//        case .setUp:
//            PKPassLibrary().openPaymentSetup()
//        case .failure:
//            break
//        }
//    }
//}
