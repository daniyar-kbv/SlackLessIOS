//
//  SLSettingsHeaderCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation
import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class SLSettingsHeaderCell: UITableViewCell {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 12, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        return view
    }()
    
    private(set) lazy var button: UIButton = {
        let view = UIButton()
        view.setTitleColor(.link, for: .normal)
        view.setTitleColor(.link.withAlphaComponent(0.5), for: .highlighted)
        view.titleLabel?.font = SLFonts.primary.getFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private let disposeBag = DisposeBag()
    var section: SLSettingsSection? {
        didSet {
            titleLabel.text = section?.title
            button.setTitle(section?.buttonTitle, for: .normal)
            button.isHidden = section?.hideButton ?? true
        }
    }
    var onTap: ((SLSettingsSection) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        bindViews()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        section = nil
        onTap = nil
    }
    
    private func bindViews() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let section = section
                else { return }
                onTap?(section)
            })
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        backgroundColor = .clear
        selectionStyle = .none

        [titleLabel, button].forEach({ contentView.addSubview($0) })
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.top.equalToSuperview()
        }
        
        button.snp.makeConstraints({
            $0.left.equalTo(titleLabel.snp.right)
            $0.right.equalToSuperview().offset(-32)
            $0.centerY.equalTo(titleLabel)
        })
    }
}
