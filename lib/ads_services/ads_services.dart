import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'dart:math' as m;

class AdsServices {
  static var sdkKey =
      "2MUk_Fq0UafQGZkmSOKcfnpy67su3ddUd6I7o77CPGESea05sQvHJKUgu3BbW9QcUp6GPRowXANMXeeT4So_Jd";
  static var bannerAdID = "be1043b515d1c606";
  static var interstitialAdID = "78008fdd25494cfa";
  static var mrecAdID = '76ba1c887fc63e9c';
  static var rewardedAdID = 'aa3f351ecca81855';

// ---------------------  Banner Initialize -----------------------------

  static adsInitialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    Map? sdkConfiguration = await AppLovinMAX.initialize(sdkKey);
  }

// ---------------------  Banner ads -----------------------------

  static Widget displayBannerAd() {
    return MaxAdView(
        adUnitId: bannerAdID,
        adFormat: AdFormat.banner,
        listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {},
            onAdLoadFailedCallback: (adUnitId, error) {},
            onAdClickedCallback: (ad) {},
            onAdExpandedCallback: (ad) {},
            onAdCollapsedCallback: (ad) {}));
  }

// ---------------------  Interstitial ads -----------------------------
  static initializeInterstitialAds() {
    var _interstitialRetryAttempt = 0;
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = m.pow(2, m.min(6, _interstitialRetryAttempt)).toInt();

        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(interstitialAdID);
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(interstitialAdID);
  }

  static displayInterstitialAds() async {
    await initializeInterstitialAds();
    bool isReady = (await AppLovinMAX.isInterstitialReady(interstitialAdID))!;
    if (isReady) {
      AppLovinMAX.showInterstitial(interstitialAdID);
    }
  }

// ---------------------  Native MREC  -------------------------------

  static Widget displayNativeMRECAd() {
    return MaxAdView(
        adUnitId: mrecAdID,
        adFormat: AdFormat.mrec,
        listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {},
            onAdLoadFailedCallback: (adUnitId, error) {},
            onAdClickedCallback: (ad) {},
            onAdExpandedCallback: (ad) {},
            onAdCollapsedCallback: (ad) {}));
  }

// ---------------------Rewarded Ads  -------------------------------

  static void initializeRewardedAds() {
    var _rewardedAdRetryAttempt = 0;

    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'
          print('Rewarded ad loaded from ' + ad.networkName);

          // Reset retry attempt
          _rewardedAdRetryAttempt = 0;
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          // Rewarded ad failed to load
          // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
          _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;

          int retryDelay = m.pow(2, m.min(6, _rewardedAdRetryAttempt)).toInt();
          print('Rewarded ad failed to load with code ' +
              error.code.toString() +
              ' - retrying in ' +
              retryDelay.toString() +
              's');

          Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
            AppLovinMAX.loadRewardedAd(rewardedAdID);
          });
        },
        onAdDisplayedCallback: (ad) {},
        onAdDisplayFailedCallback: (ad, error) {},
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {},
        onAdReceivedRewardCallback: (ad, reward) {}));
  }

  static displayRewardedAds() async {
    bool isReady = (await AppLovinMAX.isRewardedAdReady(rewardedAdID))!;
    if (isReady) {
      AppLovinMAX.showRewardedAd(rewardedAdID);
    }
  }
}
