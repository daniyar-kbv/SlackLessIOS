//
//  SLNavigationController.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

enum BarButtonConfiguration {
    case withBackButton
    case none
}

protocol NavigationLogic {
    func configure(viewController: UIViewController, in navigationController: UINavigationController) -> BarButtonConfiguration
}

@objc protocol SLNavigationControllerDelegate: AnyObject {
    func SLNavigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController)
    func SLNavigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController)
}

final class SLNavigationController: UINavigationController {
    private var observers = NSHashTable<SLNavigationControllerDelegate>.weakObjects()
    private var numberOfVCs: Int

    override init(rootViewController: UIViewController) {
        numberOfVCs = 1
        super.init(rootViewController: rootViewController)
        delegate = self
        navigationDefaultAppearance()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        numberOfVCs = 1
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
        navigationDefaultAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addObserver(_ observer: SLNavigationControllerDelegate) {
        observers.add(observer)
    }

    func removeObserver(_ observer: SLNavigationControllerDelegate) {
        observers.remove(observer)
    }

    private func navigationDefaultAppearance() {
        setNavigationBarHidden(false, animated: true)
        navigationBar.shadowImage = .init()
        navigationBar.setBackgroundImage(.init(), for: .default)
        navigationBar.backgroundColor = .clear
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold),
        ]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.isTranslucent = false
    }

    func addInsetFromTop() {
        additionalSafeAreaInsets = UIEdgeInsets(top: 21, left: 0, bottom: 0, right: 0)
    }

    func addGrabberView() {
        let grabberView = UIView()
//        grabberView.backgroundColor = SLColors.carbonGrey.getColor()
        grabberView.layer.cornerRadius = 3

        view.addSubview(grabberView)
        grabberView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(5)
            $0.width.equalTo(36)
        }
    }
}

extension SLNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        let willPush: Bool = numberOfVCs < navigationController.viewControllers.count
        numberOfVCs = navigationController.viewControllers.count

        if willPush {
            observers.allObjects.last?.SLNavigationController(navigationController, willShow: viewController)
        } else {
            observers.allObjects.forEach {
                $0.SLNavigationController(navigationController, willShow: viewController)
            }
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
        observers.allObjects.forEach {
            $0.SLNavigationController(navigationController, didShow: viewController)
        }
    }
}
