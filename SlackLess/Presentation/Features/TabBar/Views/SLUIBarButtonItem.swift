//
//  SLUIBarButtonItem.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

final class SLUIBarButtonItem: UIBarButtonItem {
    let handler: () -> Void

    init(title: String, style: UIBarButtonItem.Style, action: @escaping (() -> Void)) {
        handler = action
        super.init()

        self.title = title
        self.style = style
        setupAction()
    }

    init(image: UIImage, style: UIBarButtonItem.Style, action: @escaping (() -> Void)) {
        handler = action
        super.init()

        self.image = image
        self.style = style

        setupAction()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAction() {
        target = self
        action = #selector(handleAction)
    }

    @objc private func handleAction() {
        handler()
    }
}
