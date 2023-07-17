//
//  SummaryReportController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SummaryReportController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummaryReportView()
    private let viewModel: SummaryReportViewModel
    
    private let controllers: [SummaryPageController]
    private lazy var currentIndex = controllers.count - 1
    
    private(set) lazy var pageController: UIPageViewController = {
        let view = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.dataSource = self
        view.delegate = self
        if let lastController = controllers.last {
            view.setViewControllers([lastController],
                                    direction: .reverse,
                                    animated: false)
        }
        return view
    }()
    
    init(viewModel: SummaryReportViewModel) {
        self.viewModel = viewModel
        
        let days = viewModel.output.getDays()
        self.controllers = days.enumerated().map({
            .init(viewModel: SummaryPageViewModelImpl(day: $0.1),
                  isFirstPage: $0.0 + 1 == days.count)
        })
        
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
        
        configView()
        configNavBar()
        bindView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        contentView.pageView.snp.updateConstraints({
//            $0.height.equalTo(controllers[currentIndex].view.frame.height)
//        })
    }
    
    private func configView() {
        add(controller: pageController, to: contentView.pageView)
    }
    
    private func configNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.topItem?.title = SLTexts.Summary.title.localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func bindView() {
        contentView.dateSwitcherView.leftButton.rx.tap.bind { [weak self] in
                self?.viewModel.input.changeDate(forward: false, fromDateSwitcher: true)
            }
            .disposed(by: disposeBag)
        
        contentView.dateSwitcherView.rightButton.rx.tap.bind { [weak self] in
                self?.viewModel.input.changeDate(forward: true, fromDateSwitcher: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.output.date
            .bind(to: contentView.dateSwitcherView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isFirstDate.subscribe(onNext: { [weak self] in
                self?.contentView.dateSwitcherView.leftButton.isEnabled = !$0
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLastDate.subscribe(onNext: { [weak self] in
                self?.contentView.dateSwitcherView.rightButton.isEnabled = !$0
            })
            .disposed(by: disposeBag)
        
        viewModel.output.dateChangedForward.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            currentIndex = currentIndex + ($0 ? 1 : -1)
            pageController.setViewControllers([controllers[currentIndex]],
                                                   direction: $0 ? .forward : .reverse,
                                                   animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SummaryReportController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = currentIndex + 1
        guard nextIndex < controllers.count else { return nil }
        return controllers[nextIndex]
    }
}

extension SummaryReportController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentController = pageViewController.viewControllers?.first as? SummaryPageController,
              let newIndex = controllers.firstIndex(of: currentController)
        else { return }
        viewModel.input.changeDate(forward: newIndex > currentIndex, fromDateSwitcher: false)
        currentIndex = newIndex
    }
}
