//
//  GetStartedViewController.swift
//  PIALibrary-iOS
//
//  Created by Jose Antonio Blaya Garcia on 26/10/2018.
//  Copyright © 2018 London Trust Media. All rights reserved.
//

import UIKit

public class GetStartedViewController: AutolayoutViewController, ConfigurationAccess {

    @IBOutlet private weak var viewHeaderBackground: UIView!
    @IBOutlet private weak var viewHeader: UIView!
    @IBOutlet private weak var labelVersion: UILabel!
    @IBOutlet private weak var constraintHeaderHeight: NSLayoutConstraint!
    @IBOutlet private weak var buttonEnvironment: UIButton!
    @IBOutlet private weak var imvLogo: UIImageView!
    @IBOutlet private weak var centeredMap: UIImageView!
    
    @IBOutlet private weak var loginButton: PIAButton!
    @IBOutlet private weak var buyButton: PIAButton!
    @IBOutlet private weak var redeemButton: UIButton!
    @IBOutlet private weak var couldNotGetPlanButton: UIButton!
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public func viewDidLoad() {

        imvLogo.image = Theme.current.palette.logo
        centeredMap.image = Theme.current.palette.logo
        constraintHeaderHeight.constant = (Macros.isDeviceBig ? 250.0 : 150.0)
        buttonEnvironment.isHidden = !accessedConfiguration.isDevelopment
        labelVersion.text = Macros.localizedVersionFullString()

        self.styleButtons()
        
        super.viewDidLoad()

    }
    
    /**
     Creates a wrapped `GetStartedViewController` ready for presentation.
     */
    public static func with() -> UIViewController {
        let nav = StoryboardScene.Welcome.initialScene.instantiate()
        return nav
    }


    /// :nodoc:
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshEnvironmentButton()
    }

    @IBAction private func toggleEnvironment(_ sender: Any?) {
        if (Client.environment == .production) {
            Client.environment = .staging
        } else {
            Client.environment = .production
        }
        refreshEnvironmentButton()
    }
    
    private func refreshEnvironmentButton() {
        if (Client.environment == .production) {
            buttonEnvironment.setTitle("Production", for: .normal)
        } else {
            buttonEnvironment.setTitle("Staging", for: .normal)
        }
    }
    
    private func styleButtons() {
        loginButton.setRounded()
        buyButton.setRounded()
        
        loginButton.style(style: TextStyle.Buttons.piaGreenButton)
        buyButton.style(style: TextStyle.Buttons.piaPlainTextButton)
        
        loginButton.setTitle(L10n.Welcome.Login.submit.uppercased(),
                             for: [])
        buyButton.setTitle(L10n.Welcome.Getstarted.Buttons.buyaccount.uppercased(),
                           for: [])
        redeemButton.setTitle(L10n.Welcome.Redeem.title,
                              for: [])
        couldNotGetPlanButton.setTitle(L10n.Welcome.Login.Restore.button,
                                       for: [])
    }
    
    // MARK: Restylable
    
    /// :nodoc:
    public override func viewShouldRestyle() {
        super.viewShouldRestyle()
        
        Theme.current.applyLightBackground(viewHeaderBackground)
        Theme.current.applyLightBackground(viewHeader)
        Theme.current.applyCaption(labelVersion,
                                   appearance: .dark)
        Theme.current.applyCenteredMap(centeredMap)
        Theme.current.applyTransparentButton(buyButton,
                                             withSize: 1.0)
        buttonEnvironment.setTitleColor(labelVersion.textColor,
                                        for: .normal)
        Theme.current.applyButtonLabelStyle(redeemButton)
        Theme.current.applyButtonLabelStyle(couldNotGetPlanButton)
    }

}