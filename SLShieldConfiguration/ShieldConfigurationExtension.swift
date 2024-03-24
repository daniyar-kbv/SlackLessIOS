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
        guard let shield = repository.getShield()
        else { return makeShieldConfiguration(state: .lock) }
        guard let dayData = repository.getDayData()
        else { return makeShieldConfiguration(state: shield.state) }
        
        var timeValue: TimeInterval?
        
        switch shield.state {
        case .remind:
            timeValue = dayData.timeLimit - shield.threshold
        case .lock:
            let unlockTime = TimeInterval(dayData.unlocks * Constants.Settings.unlockMinutes * 60)
            if unlockTime > 0 {
                timeValue = unlockTime
            }
        }
        
        return makeShieldConfiguration(state: shield.state, timeValue: timeValue)
    }
    
    private func makeShieldConfiguration(state: SLShield.State, timeValue: TimeInterval? = nil) -> ShieldConfiguration {
        .init(backgroundBlurStyle: .regular,
                     backgroundColor: UIColor.random(),
                     icon: SLImages.getEmoji(.allCases.randomElement()!),
                     title: .init(text: SLTexts.Shield.title.localized(),
                                  color: SLColors.white.getColor() ?? .white),
                     subtitle: .init(text: state.getSubtitle(with: timeValue),
                                     color: SLColors.white.getColor() ?? .white),
                     primaryButtonLabel: .init(text: state.getPrimaryButtonTitle(),
                                               color: SLColors.black.getColor() ?? .black),
                     primaryButtonBackgroundColor: SLColors.white.getColor(),
                     secondaryButtonLabel: .init(text: state.getSecondaryButtonTitle(with: TimeInterval(Constants.Settings.unlockMinutes*60)),
                                                 color: SLColors.white.getColor() ?? .white))
    }
}
