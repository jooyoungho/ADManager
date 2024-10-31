//
//  InterstitialAD.swift
//  
//
//  Created by JooYoungho on 3/12/24.
//

import Foundation
import GoogleMobileAds

public final class InterstitialAD: NSObject, GADFullScreenContentDelegate {
    public var interstitialAD: GADInterstitialAd?
    var completion: (() -> Void)?
    var adUnitID: String

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        loadAD()
    }

    public func loadAD() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: self.adUnitID, request: request) { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            self.interstitialAD = ad
            self.interstitialAD?.fullScreenContentDelegate = self
        }
    }

    public func showAD(completion: @escaping () -> Void) {
        self.completion = completion
        if let ad = interstitialAD {
            ad.present(fromRootViewController: UIApplication.shared.keyWindowPresentedController!)
        } else {
            print("Ad wasn't ready")
        }
    }

    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        completion?()
        loadAD()
    }
}
