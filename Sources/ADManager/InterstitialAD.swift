//
//  InterstitialAD.swift
//  
//
//  Created by JooYoungho on 3/12/24.
//

import Foundation
import GoogleMobileAds

public final class InterstitialAD: NSObject, GADFullScreenContentDelegate {
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
        GADRewardedAd.load(withAdUnitID: self.adUnitID, request: request) { (ad, error) in
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
                _ = ad.adReward
                rewardFunction()
                self.loadRewarded()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}
