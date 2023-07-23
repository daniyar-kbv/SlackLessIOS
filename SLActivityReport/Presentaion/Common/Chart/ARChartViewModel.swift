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
    func getMaxTime() -> TimeInterval
    func getScaleInfo() -> (times: [TimeInterval], proportions: Double)
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
    
    func getMaxTime() -> TimeInterval {
        return items.map({ $0.getTotalTime() }).max() ?? 0
    }
    
    func getScaleInfo() -> (times: [TimeInterval], proportions: Double) {
        let maxTimeItem = items.max(by: { $0.getTotalTime() < $1.getTotalTime() })
        let maxViewSize = Constants.screenSize.width - 84
        var maxBarSize: CGFloat?
        
        switch type {
        case .horizontal:
            maxBarSize = Constants.screenSize.width - (maxTimeItem?.getTotalTimeFormatted()?.width(withConstrainedHeight: 20, font: SLFonts.primary.getFont(ofSize: 11, weight: .regular)) ?? 0) - 104
            
        case .vertical:
            break
        }
        
        guard let maxBarSize = maxBarSize,
              let maxTime = maxTimeItem?.getTotalTime()
        else { return (times: [], proportions: 0.0) }
        
        var barSize = 0.0
        var maxScaleTime = 100
        for i in stride(from: 0, through: 100, by: 4).reversed() {
            let newBarSize = maxTime/(Double(i)*3600)*maxViewSize
            if newBarSize > barSize && newBarSize < maxBarSize {
                barSize = newBarSize
                maxScaleTime = i
            }
        }
        
        return (times: stride(from: 0.0, through: Double(maxScaleTime), by: Double(maxScaleTime)/4.0).dropFirst().map({ $0*3600 }),
                proportions: barSize/Double(maxViewSize))
    }
    
    //    Input
    
    func set(items: [GraphRepresentable]) {
        self.items = items
    }
}
