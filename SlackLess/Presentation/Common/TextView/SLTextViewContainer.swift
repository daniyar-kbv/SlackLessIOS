//
//  SLTextViewContainer.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SLTextViewContainer: UIStackView {
    private let disposeBag = DisposeBag()
    
    let textChanged = PublishRelay<String>()
    let didStartEditing = PublishRelay<String>()
    let didEndEditing = PublishRelay<String>()
    
    private(set) var state: State = .normal {
        didSet {
            textView.set(state: state.textViewState)
            
            var hideErrorLabel = true
            
            switch state {
            case .normal:
                break
            case let .error(error):
                errorLabel.text = error.presentationDescription
                hideErrorLabel = false
            }
            
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.errorLabel.isHidden = hideErrorLabel
            }
        }
    }
    
    var bottomText: String? {
        didSet {
            bottomLabel.text = bottomText
            bottomLabel.isHidden = bottomText?.isEmpty ?? true
        }
    }
    
    private(set) lazy var textView = SLTextView()
    
    private(set) lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 12, weight: .regular)
        view.textColor = SLColors.red.getColor()
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    private(set) lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 12, weight: .regular)
        view.textColor = SLColors.gray1.getColor()
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
        bindView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 8
        
        [textView, errorLabel, bottomLabel].forEach({ addArrangedSubview($0) })
        
        textView.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview()
        })
        
        errorLabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        bottomLabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
    }
    
    private func bindView() {
        textView.rx.text
            .subscribe(onNext: { [weak self] in
                guard let text = $0 else { return }
                self?.textChanged.accept(text)
            })
            .disposed(by: disposeBag)
        
        textView.didStartEditing
            .bind(to: didStartEditing)
            .disposed(by: disposeBag)
        
        textView.didEndEditing
            .bind(to: didEndEditing)
            .disposed(by: disposeBag)
    }
}

extension SLTextViewContainer {
    func set(state: State) {
        self.state = state
    }
}

extension SLTextViewContainer {
    enum State: Equatable {
        case normal
        case error(ErrorPresentable)
        
        var textViewState: SLTextView.State {
            switch self {
            case .normal: return .normal
            case .error: return .error
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.normal, .normal), (.error, .error): return true
            default: return false
            }
        }
    }
}
