//
//  RewardedAD.swift
//
//
//  Created by JooYoungho on 3/12/24.
//

import Foundation
import GoogleMobileAds

public final class RewardedAD: NSObject, GADFullScreenContentDelegate {
    var rewardedAd: GADRewardedAd?
    var rewardFunction: (() -> Void)?
    var adUnitID: String

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        loadRewarded()
    }

    public func loadRewarded() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: self.adUnitID, request: request) { [weak self] (ad, error) in
            guard let self = self else { return }
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    public func showAd(rewardFunction: @escaping () -> Void) {
        self.rewardFunction = rewardFunction
        if let ad = rewardedAd {
            ad.present(fromRootViewController: UIApplication.shared.keyWindowPresentedController!) {
                self.rewardFunction?()
                self.loadRewarded()
            }
        } else {
            print("Ad wasn't ready")
        }
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        rewardFunction?()
    }
}
