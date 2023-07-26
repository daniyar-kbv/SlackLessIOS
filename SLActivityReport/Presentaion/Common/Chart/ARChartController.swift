//
//  ARChartController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ARChartController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var contentView = ARChartView(type: viewModel.output.getType())
    private let viewModel: ARChartViewModel
    
    init(viewModel: ARChartViewModel) {
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
        bindViewModel()
    }
    
    private func configureView() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.output.reload
            .subscribe(onNext: contentView.collectionView.reloadData)
            .disposed(by: disposeBag)
    }
}

extension ARChartController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.output.getType() {
        case .horizontal: return 8
        case .vertical: return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.output.getType() {
        case .horizontal:
            if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ARChartCollectionScaleCell.self), for: indexPath) as! ARChartCollectionScaleCell
                cell.set(type: viewModel.output.getType(),
                         times: viewModel.output.getTimes())
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ARChartCollectionBarCell.self), for: indexPath) as! ARChartCollectionBarCell
            cell.set(type: viewModel.output.getType(),
                     item: viewModel.output.getItem(for: indexPath.item),
                     size: viewModel.output.getSizeForItem(at: indexPath.item))
            return cell
        case .vertical:
            return UICollectionViewCell()
        }
    }
}

extension ARChartController: UICollectionViewDelegate {
    
}

extension ARChartController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.output.getType() {
        case .horizontal:
            if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                return .init(width: collectionView.frame.width, height: 20)
            }
            return .init(width: collectionView.frame.width, height: 30)
        case .vertical:
            return .init(width: 0, height: 0)
        }
    }
}
