//
//  RewardedAD.swift
//
//
//  Created by JooYoungho on 3/12/24.
//

import Foundation
import GoogleMobileAds

public final class RewardedAD: NSObject, GADFullScreenContentDelegate {
    var rewardedAD: GADRewardedAd?
    var completion: (() -> Void)?
    var adUnitID: String

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        loadAD()
    }

    public func loadAD() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: self.adUnitID, request: request) { [weak self] (ad, error) in
            guard let self = self else { return }
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            self.rewardedAD = ad
            self.rewardedAD?.fullScreenContentDelegate = self
        }
    }

    public func showAD(completion: @escaping () -> Void) {
        self.completion = completion
        if let ad = rewardedAD, let rootViewController = UIApplication.shared.keyWindowPresentedController {
            ad.present(fromRootViewController: rootViewController) { [weak self] in
                self?.completion?()
                self?.loadAD()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}
