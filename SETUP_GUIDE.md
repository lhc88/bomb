# 신시 봄버맨 프로젝트 설정 가이드

## ✅ 완료된 작업

### 1. 프로젝트 생성
- Flutter 3.41.5로 프로젝트 초기화
- 패키지명: `com.sinsi.bomberman`
- 앱 이름: `신시 봄버맨`
- Android 최소 SDK: API 21 설정

### 2. pubspec.yaml 설정
다음 패키지들이 추가되었습니다:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # Game Engine & Audio
  flame: ^1.17.0
  flame_audio: ^2.5.0
  
  # Monetization
  google_mobile_ads: ^4.0.0
  in_app_purchase: ^3.1.10
  
  # Storage
  shared_preferences: ^2.2.2
```

### 3. 폴더 구조 생성
```
lib/
├── main.dart
├── models/                    (데이터 모델)
│   ├── hero.dart
│   ├── monster.dart
│   ├── player.dart
│   └── stage.dart
├── screens/                   (UI 화면)
│   └── home_screen.dart
├── services/                  (게임 로직)
│   ├── game_service.dart
│   ├── save_service.dart
│   ├── ads_service.dart
│   └── iap_service.dart
├── game/                      (Flame 게임 엔진)
│   ├── sinsi_game.dart
│   ├── components/
│   │   ├── hero_component.dart
│   │   ├── monster_component.dart
│   │   └── stage_component.dart
│   └── systems/
│       ├── battle_system.dart
│       ├── skill_system.dart
│       └── animation_system.dart
└── utils/
    ├── constants.dart
    └── theme.dart

assets/
├── images/
├── backgrounds/
├── heroes/
├── monsters/
├── ui/
├── audio/
└── fonts/
```

### 4. 생성된 파일들

**모델 (lib/models/)**
- `hero.dart` - 영웅 클래스 (5등급 레어도, 스킬, 장비, 돌파 등)
- `player.dart` - 플레이어 데이터 (골드, 신화석, 오프라인 보상 등)
- `stage.dart` - 스테이지 데이터 (80개 스테이지, 보상 계산)
- `monster.dart` - 몬스터 데이터 (HP, DPS, 스케일링)

**서비스 (lib/services/)**
- `game_service.dart` - 게임 로직 (전투 시뮬레이션, 가챠, 플레이어 관리)
- `save_service.dart` - SharedPreferences 기반 저장 시스템
- `ads_service.dart` - Google Mobile Ads 통합
- `iap_service.dart` - 인앱결제 (신화석, 월정액 패스)

**게임 엔진 (lib/game/)**
- `sinsi_game.dart` - Flame 메인 게임 클래스
- `systems/battle_system.dart` - 전투 시스템
- `systems/skill_system.dart` - 스킬 시스템
- `systems/animation_system.dart` - 애니메이션 시스템
- `components/` - 게임 컴포넌트들

**UI (lib/screens/)**
- `home_screen.dart` - 메인 홈 화면 (플레이어 정보, 영웅, 전투, 상점, 설정)

**유틸리티 (lib/utils/)**
- `constants.dart` - 게임 상수 (앱 정보, 스테이지, 가챠율 등)
- `theme.dart` - 다크 테마 (한국 신화 색상)

### 5. Android 설정
- `android/app/build.gradle.kts` 확인 완료
- `android/app/src/main/AndroidManifest.xml` 업데이트
  - 필수 권한 추가 (인터넷, 네트워크)
  - 앱 라벨을 "신시 봄버맨"으로 설정

### 6. main.dart 기본 구조
- MaterialApp 설정 완료
- 다크 테마 적용
- 영어/한국어 지역화 설정
- HomeScreen을 초기 화면으로 설정

## 🚀 다음 단계

### 필수 작업

1. **AdMob 설정**
   - Google AdMob에 앱 등록
   - Banner ID와 Interstitial ID 받기
   - `lib/utils/constants.dart`의 다음 값 업데이트:
   ```dart
   static const String admobBannerId = 'ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy';
   static const String admobInterstitialId = 'ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy';
   ```

2. **Google Play Console 설정**
   - 인앱결제 제품 ID 생성:
     - `com.sinsi.mythicstones50`
     - `com.sinsi.mythicstones100`
     - `com.sinsi.mythicstones500`
     - `com.sinsi.seasonpass.monthly`
     - `com.sinsi.starterpack`

3. **에셋 추가**
   - `assets/images/` - 게임 이미지
   - `assets/backgrounds/` - 배경 이미지
   - `assets/heroes/` - 영웅 이미지
   - `assets/monsters/` - 몬스터 이미지
   - `assets/audio/` - 음향 효과 및 배경음악

4. **폰트 추가**
   - `assets/fonts/NotoSansKR-Regular.ttf`
   - `assets/fonts/NotoSansKR-Bold.ttf`

### 선택적 작업

1. **추가 화면 구현**
   - 영웅 리스트 화면 (`screens/hero_list_screen.dart`)
   - 전투 화면 (`screens/battle_screen.dart`)
   - 상점 화면 (`screens/shop_screen.dart`)
   - 설정 화면 (`screens/settings_screen.dart`)

2. **게임 데이터**
   - 모든 영웅 정의
   - 모든 스테이지 정의
   - 모든 몬스터 정의
   - 스킬 데이터

3. **로컬라이제이션**
   - 한국어 번역 완료
   - 영어 번역 추가

## 🎮 실행 방법

```bash
# 의존성 설치 (이미 완료됨)
flutter pub get

# 앱 실행
flutter run

# 릴리스 빌드
flutter build apk --release
```

## 📱 Android 빌드 설정

### build.gradle.kts 확인 사항
- compileSdk: Flutter 최신 버전
- minSdk: 21 (API 21)
- targetSdk: 자동 설정

### 서명 설정 (Google Play 배포 시)

`android/app/build.gradle.kts`의 release 섹션을 수정:

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

key.jks 파일 생성:
```bash
keytool -genkey -v -keystore ~/sinsi.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sinsi-key
```

## 📊 프로젝트 통계

- **총 파일 수**: 19개 Dart 파일
- **모델**: 4개 (Hero, Player, Stage, Monster)
- **서비스**: 4개 (Game, Save, Ads, IAP)
- **UI 화면**: 1개 (HomeScreen - 프레임)
- **게임 엔진**: 7개 (Game, BattleSystem, SkillSystem, AnimationSystem, 3 Components)
- **유틸리티**: 2개 (Constants, Theme)

## 📖 파일 설명

### 핵심 게임 로직
- `models/hero.dart` - 5등급 영웅, 스킬, 장비, 돌파 시스템
- `models/player.dart` - 플레이어 데이터, 오프라인 보상 계산
- `models/stage.dart` - 80개 스테이지, 난이도 배율, 보상 계산
- `models/monster.dart` - 스케일링, HP, DPS

### 게임 로직
- `services/game_service.dart` - 전투 시뮬레이션, 가챠 시스템
- `services/save_service.dart` - SharedPreferences 저장
- `services/ads_service.dart` - AdMob 광고
- `services/iap_service.dart` - 인앱결제

### 게임 시스템
- `game/systems/battle_system.dart` - 실시간 전투 계산
- `game/systems/skill_system.dart` - 스킬 쿨다운, 데미지 계산
- `game/systems/animation_system.dart` - 데미지 팝업, 이펙트

## ⚠️ 주의사항

1. AdMob ID와 IAP 제품 ID는 반드시 설정해야 함
2. 에셋 파일들은 pubspec.yaml에 등록되어야 함
3. 폰트 파일은 반드시 assets/fonts/ 폴더에 저장해야 함
4. 장기 개발을 위해 데이터베이스 마이그레이션 계획 필요

## 🔗 참고 자료

- [Flutter 공식 문서](https://flutter.dev)
- [Flame 게임 엔진](https://flame-engine.org)
- [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads)
- [In-App Purchase](https://pub.dev/packages/in_app_purchase)

---

**프로젝트 생성일**: 2026-03-29  
**기획서 버전**: v2.0  
**개발자**: Claude Code + 이희창
