import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/main_screen.dart';
import 'managers/ad_manager.dart';
import 'managers/save_manager.dart';
import 'managers/localization_manager.dart';
import 'managers/sound_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 저장 시스템 초기화 (필수)
  await SaveManager().initialize();

  // 로컬라이제이션 초기화
  LocalizationManager().initialize('ko');

  // 사운드 시스템 초기화
  await SoundManager().initialize();

  // 광고 초기화 (백그라운드에서 진행)
  Future.microtask(() async {
    try {
      await AdManager().initialize();
      AdManager().loadBannerAd();
      AdManager().loadInterstitialAd();
    } catch (e) {
      print('Ad initialization failed: $e');
    }
  });

  runApp(const BombermanApp());
}

class BombermanApp extends StatelessWidget {
  const BombermanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '신시 봄버맨',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8B0000),
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B0000),
          elevation: 0,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ko', 'KR'),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
