//
//  FeedbackController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FeedbackController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: FeedbackViewModel
    private lazy var contentView = FeedbackView()
    
    private var didLayoutSubviews = false

    init(viewModel: FeedbackViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didLayoutSubviews {
            let availableSpace = contentView.largeTitleView.frame.height -
            contentView.largeTitleView.mainStackView.frame.height - 32
            let fieldMaxHeight = (availableSpace / 2) + contentView.emailTextView.frame.height
            
            contentView.bodyTextView.snp.makeConstraints({
                $0.height.lessThanOrEqualTo(fieldMaxHeight)
            })
            
            contentView.emailTextView.snp.makeConstraints({
                $0.height.lessThanOrEqualTo(fieldMaxHeight)
            })
        }
        
        didLayoutSubviews = true
    }

    private func configureView() {
        
    }

    private func bindView() {
        contentView.bodyTextView.didStartEditing
            .subscribe(onNext: { [weak self] _ in
                switch self?.contentView.bodyTextView.state {
                case .error: self?.contentView.bodyTextView.set(state: .normal)
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        contentView.emailTextView.didStartEditing
            .subscribe(onNext: { [weak self] _ in
                switch self?.contentView.emailTextView.state {
                case .error: self?.contentView.emailTextView.set(state: .normal)
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        contentView.bodyTextView.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.didFinishEditing(text: $0, type: .body)
            })
            .disposed(by: disposeBag)
        
        contentView.emailTextView.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.didFinishEditing(text: $0, type: .email)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.output.isComplete
            .bind(to: contentView.button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.errorOccured
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .emptyBody: self?.contentView.bodyTextView.set(state: .error($0))
                case .invalidEmail: self?.contentView.emailTextView.set(state: .error($0))
                }
            })
            .disposed(by: disposeBag)
    }
}

//  TODO: Refactor to use ErrorUI

extension FeedbackController {
    enum Error: ErrorPresentable {
        case invalidEmail
        case emptyBody
        
        var presentationDescription: String {
            switch self {
            case .invalidEmail: return SLTexts.Feedback.Error.invalidEmail.localized()
            case .emptyBody: return SLTexts.Feedback.Error.bodyEmpty.localized()
            }
        }
    }
}
