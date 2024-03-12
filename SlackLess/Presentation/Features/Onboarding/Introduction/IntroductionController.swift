//
//  IntroductionController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-10.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class IntroductionController: UIViewController {
    private let viewModel: IntroductionViewModel
    private lazy var contentView = IntroductionView()
    private let disposeBag = DisposeBag()
    
    private var previousCollectionViewSize: CGSize = .zero
    private var collectionViewSize: CGSize = .zero {
        didSet { handleCollectionViewSizeChange() }
    }
    
    init(viewModel: IntroductionViewModel) {
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
        
        configure()
        bindView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionViewSize = contentView.collectionView.frame.size
    }
    
    private func configure() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    private func bindView() {
        contentView.button.rx.tap
            .subscribe(onNext: viewModel.input.buttonTapped)
            .disposed(by: disposeBag)
        
        contentView.pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                viewModel.input.scrolled(to: contentView.pageControl.currentPage)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.output.reloadData
            .subscribe(onNext: contentView.collectionView.reloadData)
            .disposed(by: disposeBag)
        
        viewModel.output.currentStateIndex
            .subscribe(onNext: handleIndexChange(_:))
            .disposed(by: disposeBag)
        
        viewModel.output.numberOfStates
            .bind(to: contentView.pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        viewModel.output.buttonTitle
            .bind(to: contentView.button.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func handleCollectionViewSizeChange() {
        if previousCollectionViewSize != collectionViewSize {
            contentView.collectionView.reloadData()
        }
        previousCollectionViewSize = collectionViewSize
    }
    
    private func handleIndexChange(_ index: Int) {
        contentView.pageControl.currentPage = index
        contentView.collectionView.scrollToItem(at: .init(item: index, section: 0),
                                                at: .centeredHorizontally,
                                                animated: true)
    }
}

extension IntroductionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.numberOfStates.value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IntroductionCollectionCell.self), for: indexPath) as! IntroductionCollectionCell
        cell.state = viewModel.output.getState(at: indexPath.row)
        return cell
    }
}

extension IntroductionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionViewSize.width >= 32 else { return .zero }
        return .init(width: collectionViewSize.width-32,
                     height: collectionViewSize.height)
    }
}

extension IntroductionController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.input.scrolled(to: Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))
    }
}
