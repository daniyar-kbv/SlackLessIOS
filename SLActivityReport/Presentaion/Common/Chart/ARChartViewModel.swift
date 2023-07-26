//
//  ARChartViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-21.
//

import Foundation
import RxSwift
import RxCocoa

protocol ARChartViewModelInput {
    func set(items: [GraphRepresentable])
}

protocol ARChartViewModelOutput {
    var reload: PublishRelay<Void> { get }
    
    func getType() -> ARChartType
    func getItem(for index: Int) -> GraphRepresentable
    func getTimes() -> [TimeInterval]
    func getSizeForItem(at index: Int) -> CGFloat
}

protocol ARChartViewModel: AnyObject {
    var input: ARChartViewModelInput { get }
    var output: ARChartViewModelOutput { get }
}

final class ARChartViewModelImpl: ARChartViewModel, ARChartViewModelInput, ARChartViewModelOutput {
    var input: ARChartViewModelInput { self }
    var output: ARChartViewModelOutput { self }
    
    let type: ARChartType
    var items: [GraphRepresentable] {
        didSet {
            reload.accept(())
        }
    }
    
    init(type: ARChartType,
         items: [GraphRepresentable]) {
        self.type = type
        self.items = items
    }
    
    //    Output
    let reload: PublishRelay<Void> = .init()
    
    func getType() -> ARChartType {
        type
    }
    
    func getItem(for index: Int) -> GraphRepresentable {
        items[index]
    }
    
    func getTimes() -> [TimeInterval] {
        var maxViewSize: CGFloat?
        
        switch type {
        case .horizontal: maxViewSize = Constants.screenSize.width - 84
        case .vertical: break
        }
        
        guard let maxBarSize = getMaxSize(),
              let maxTime = getMaxItem()?.getTotalTime(),
              let maxViewSize = maxViewSize
        else { return [] }
        
        var barSize = 0.0
        var maxScaleTime = 100
        for i in stride(from: 0, through: 100, by: 4).reversed() {
            let newBarSize = maxTime/(Double(i)*3600)*maxViewSize
            if newBarSize > barSize && newBarSize < maxBarSize {
                barSize = newBarSize
                maxScaleTime = i
            }
        }
        return stride(from: 0.0, through: Double(maxScaleTime), by: Double(maxScaleTime)/4.0).dropFirst().map({ $0*3600 })
    }
    
    func getSizeForItem(at index: Int) -> CGFloat {
        guard let maxTotalTime = getMaxItem()?.getTotalTime(),
              let maxSize = getMaxSize()
        else { return 0 }
        return (items[index].getTotalTime()/maxTotalTime)*maxSize
    }
    
    //    Input
    
    func set(items: [GraphRepresentable]) {
        self.items = items
    }
}

extension ARChartViewModelImpl {
    private func getMaxItem() -> GraphRepresentable? {
        items.max(by: { $0.getTotalTime() < $1.getTotalTime() })
    }
    
    private func getMaxSize() -> CGFloat? {
        var maxBarSize: CGFloat?
        
        switch type {
        case .horizontal:
            maxBarSize = Constants.screenSize.width - (getMaxItem()?.getTotalTimeFormatted()?.width(withConstrainedHeight: 20, font: SLFonts.primary.getFont(ofSize: 11, weight: .regular)) ?? 0) - 104
        case .vertical:
            break
        }
        
        return maxBarSize
    }
}
