//
//  SelectAppsButtonView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-25.
//

import Foundation
import SwiftUI
import RxSwift
import RxCocoa

struct SelectAppsButtonView: UIViewRepresentable {
    private let disposeBag = DisposeBag()
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = SLButton(style: .contrastBackground, size: .large)
        view.setTitle("Select Apps", for: .normal)
        view.rx.tap
            .subscribe(onNext: {
                action()
            })
            .disposed(by: disposeBag)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
