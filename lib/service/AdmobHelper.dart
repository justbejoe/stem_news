
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {
  InterstitialAd _interstitialAd;

  int num_of_attempt_load = 0;

  static initialization() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  void createInterAd() {
    InterstitialAd.load(adUnitId: "ca-app-pub-2556925170225238/8206502664",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            num_of_attempt_load = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            num_of_attempt_load + 1;
            _interstitialAd = null;

            if (num_of_attempt_load <= 2) {
              createInterAd();
            }
          }),
    );
  }
  void showInterAd(){
    if (_interstitialAd== null){
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(

        onAdShowedFullScreenContent: (InterstitialAd ad){
          print('ad onAdShowedFullScreen');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad){
          ad.dispose();
          print('ad Disposed');
        }
    );
    _interstitialAd.show();

    _interstitialAd= null;

  }
}