//
//  BenefitsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-12.
//

import Foundation
import RxSwift
import RxCocoa

protocol BenefitsViewModelInput: AnyObject {
    func continueTapped()
}

protocol BenefitsViewModelOutput: AnyObject {
    var didFinish: PublishRelay<Void> { get }
    func getNumberOfBenefits() -> Int
    func getBenefitType(at index: Int) -> BenefitType?
}

protocol BenefitsViewModel: AnyObject {
    var input: BenefitsViewModelInput { get }
    var output: BenefitsViewModelOutput { get }
}

final class BenefitsViewModelImpl: BenefitsViewModel, BenefitsViewModelInput, BenefitsViewModelOutput {
    var input: BenefitsViewModelInput { self }
    var output: BenefitsViewModelOutput { self }
    
    private let onboardingService: OnboardingService
    private lazy var benefitTypes = makeBenefits()
    
    init(onboardingService: OnboardingService) {
        self.onboardingService = onboardingService
    }
    
//    Output
    var didFinish: PublishRelay<Void> = .init()
    
    func getNumberOfBenefits() -> Int {
        benefitTypes.count
    }
    
    func getBenefitType(at index: Int) -> BenefitType? {
        guard index < benefitTypes.count else { return nil }
        return benefitTypes[index]
    }
    
//    Input
    func continueTapped() {
        didFinish.accept(())
    }
}

extension BenefitsViewModelImpl {
    private func makeBenefits() -> [BenefitType] {
        let benefits = onboardingService.output.getBenefits()
        return [
            .freeYourself,
            .reduceTime(time: benefits.time.getMaxTimeUnit() ?? "1 hour"),
            .reviewProgress(percentage: "\(Int(benefits.percentage*100))%")
        ]
    }
}
