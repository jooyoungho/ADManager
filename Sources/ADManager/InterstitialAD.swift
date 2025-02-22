//
//  InterstitialAD.swift
//  
//
//  Created by JooYoungho on 3/12/24.
//

import Foundation
import GoogleMobileAds

public final class InterstitialAD: NSObject, FullScreenContentDelegate {
    public var interstitialAD: InterstitialAd?
    var completion: (() -> Void)?
    var adUnitID: String

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        loadAD()
    }

    public func loadAD() {
        let request = Request()
        InterstitialAd.load(with: self.adUnitID, request: request) { (ad, error) in
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
        if let ad = interstitialAD, let rootViewController = UIApplication.shared.keyWindowPresentedController {
            ad.present(from: rootViewController)
        } else {
            print("Ad wasn't ready")
        }
    }

    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        completion?()
        loadAD()
    }
}
