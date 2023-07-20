//
//  ARView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-18.
//

import Foundation
import UIKit
import SnapKit

class ARView: UIView {
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: view.safeAreaLayoutGuide.layoutFrame.size.height, left: 0, bottom: 16, right: 0)
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 28, weight: .bold)
        view.textColor = SLColors.label1.getColor()
        return view
    }()
    
    fileprivate lazy var contentView = SLContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(view: UIView) {
        contentView.addArrangedSubview(view)
    }
    
    private func layoutUI() {
        backgroundColor = SLColors.background1.getColor()
        
        [scrollView].forEach(addSubview(_:))
        
        scrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [titleLabel, contentView].forEach(scrollView.addSubview(_:))
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        })
        
        contentView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().inset(16)
        })
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}

