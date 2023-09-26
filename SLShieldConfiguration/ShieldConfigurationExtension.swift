//
//  ShieldConfigurationExtension.swift
//  SLShieldConfiguration
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding _: Application) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    override func configuration(shielding _: Application, in _: ActivityCategory) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    override func configuration(shielding _: WebDomain) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    override func configuration(shielding _: WebDomain, in _: ActivityCategory) -> ShieldConfiguration {
        makeShieldConfiguration()
    }

    private func makeShieldConfiguration() -> ShieldConfiguration {
//        .init()
        .init(backgroundBlurStyle: .light,
              backgroundColor: SLColors.accent1.getColor(),
              icon: SLImages.Common.logo.getImage(),
              title: .init(text: SLTexts.Shield.title.localized(),
                           color: SLColors.white.getColor() ?? .white),
              subtitle: .init(text: SLTexts.Shield.subtitle.localized(),
                              color: SLColors.white.getColor() ?? .white),
              primaryButtonLabel: .init(text: SLTexts.Shield.primaryButtonTitle.localized(),
                                        color: SLColors.black.getColor() ?? .black),
              primaryButtonBackgroundColor: SLColors.white.getColor(),
              secondaryButtonLabel: .init(text: SLTexts.Shield.secondaryButtonTitle.localized(),
                                          color: SLColors.white.getColor() ?? .white))
    }
}
