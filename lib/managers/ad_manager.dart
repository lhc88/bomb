import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();

  late BannerAd? _bannerAd;
  late InterstitialAd? _interstitialAd;
  late RewardedAd? _rewardedAd;

  // AdMob 테스트 ID
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  AdManager._internal() {
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
  }

  factory AdManager() {
    return _instance;
  }

  // 초기화
  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      print('AdMob 초기화 실패: $e');
    }
  }

  // 배너 광고 로드
  Future<void> loadBannerAd() async {
    try {
      _bannerAd = BannerAd(
        adUnitId: testBannerId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('배너 광고 로드됨');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('배너 광고 로드 실패: $error');
            ad.dispose();
            _bannerAd = null;
          },
        ),
      );
      _bannerAd?.load();
    } catch (e) {
      print('배너 광고 로드 에러: $e');
    }
  }

  // 전면 광고 로드
  Future<void> loadInterstitialAd() async {
    try {
      InterstitialAd.load(
        adUnitId: testInterstitialId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            print('전면 광고 로드됨');
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('전면 광고 로드 실패: $error');
          },
        ),
      );
    } catch (e) {
      print('전면 광고 로드 에러: $e');
    }
  }

  // 보상형 광고 로드
  Future<void> loadRewardedAd() async {
    try {
      RewardedAd.load(
        adUnitId: testRewardedId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            print('보상형 광고 로드됨');
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('보상형 광고 로드 실패: $error');
          },
        ),
      );
    } catch (e) {
      print('보상형 광고 로드 에러: $e');
    }
  }

  // 배너 광고 반환
  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  // 전면 광고 표시
  Future<void> showInterstitialAd() async {
    try {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            ad.dispose();
            _interstitialAd = null;
            loadInterstitialAd(); // 다음 광고 로드
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
            print('전면 광고 표시 실패: $error');
            ad.dispose();
            _interstitialAd = null;
          },
        );
        _interstitialAd!.show();
      }
    } catch (e) {
      print('전면 광고 표시 에러: $e');
    }
  }

  // 보상형 광고 표시
  Future<void> showRewardedAd({required Function onRewardEarned}) async {
    try {
      if (_rewardedAd != null) {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            ad.dispose();
            _rewardedAd = null;
            loadRewardedAd(); // 다음 광고 로드
          },
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            print('보상형 광고 표시 실패: $error');
            ad.dispose();
            _rewardedAd = null;
          },
        );

        _rewardedAd!.show(
          onUserEarnedReward: (ad, RewardItem reward) {
            print('보상 획득: ${reward.amount}');
            onRewardEarned();
          },
        );
      }
    } catch (e) {
      print('보상형 광고 표시 에러: $e');
    }
  }

  // 광고 정리
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
