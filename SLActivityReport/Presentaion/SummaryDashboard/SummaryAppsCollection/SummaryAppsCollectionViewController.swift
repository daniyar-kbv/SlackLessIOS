//
//  SummaryAppsCollectionViewController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit

final class SummaryAppsCollectionViewController: UIViewController {
    let contentView = SummaryAppsCollectionView()
    private let viewModel: SummaryAppsCollectionViewModel
    
    init(viewModel: SummaryAppsCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        
        super.loadView()
    }
    
    override func viewDidLoad() {
        configure()
    }
    
    private func configure() {
        contentView.appsCollectionView.dataSource = self
    }
}

extension SummaryAppsCollectionViewController {
    func getContentView() -> UIView {
        return contentView
    }
}

extension SummaryAppsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.appsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SummaryAppsCollectionCell.self),
                                                                      for: indexPath) as! SummaryAppsCollectionCell
        let appInfo = viewModel.output.getAppInfoItem(for: indexPath.item)
        cell.appTimeView.setAppIcon(appInfo.image)
        cell.appTimeView.setAppTime(appInfo.time)
        cell.appTimeView.setTimeBarLength(viewModel.output.getAppTimeLength(for: indexPath.item))
        return cell
    }
}

extension SummaryAppsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: contentView.frame.width-80, height: 28)
    }
}
