//
//  ShieldConfigurationExtension.swift
//  SLShieldConfiguration
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import RxSwift
import RxCocoa

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let dataComponentsFactory: DataComponentsFactory = DataComponentsFactoryImpl()
    private lazy var repository: Repository = dataComponentsFactory.makeRepository()
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    override func configuration(shielding application: Application, in _: ActivityCategory) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain, in _: ActivityCategory) -> ShieldConfiguration {
        makeShieldConfiguration()
    }
    
    private func makeShieldConfiguration() -> ShieldConfiguration {
        guard let dayData = repository.getDayData(),
              let shield = repository.getShield()
        else { return .init() }
        
        let timeValue = abs(dayData.timeLimit-shield.threshold)
        return .init(backgroundBlurStyle: .systemUltraThinMaterialLight,
                     backgroundColor: UIColor.random(),
                     icon: SLImages.getEmoji(.allCases.randomElement()!),
                     title: .init(text: SLTexts.Shield.title.localized(),
                                  color: SLColors.white.getColor() ?? .white),
                     subtitle: .init(text: shield.state.getSubtitle(with: timeValue),
                                     color: SLColors.white.getColor() ?? .white),
                     primaryButtonLabel: .init(text: SLTexts.Shield.primaryButtonTitle.localized(),
                                               color: SLColors.black.getColor() ?? .black),
                     primaryButtonBackgroundColor: SLColors.white.getColor(),
                     secondaryButtonLabel: shield.state.getSecondaryButtonLabel(with: Constants.Settings.unlockTime))
    }
}
