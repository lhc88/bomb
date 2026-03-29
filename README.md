# 신시 봄버맨 🎮

한국 신화를 배경으로 한 봄버맨 게임입니다. 신시의 10가지 캐릭터를 선택하여 40개의 스테이지에서 4가지 요괴를 무찌르세요!

## 📱 프로젝트 정보

- **앱 이름**: 신시 봄버맨
- **패키지명**: com.sinsi.bomberman
- **개발 언어**: Dart (Flutter 3.x)
- **게임 엔진**: Flame 1.x
- **타겟 플랫폼**: Android (Google Play)
- **최소 SDK**: API 21

## 🎮 게임 특징

- **10가지 캐릭터**: 단군, 환웅, 주몽, 바리데기, 유리, 선덕여왕, 을지문덕, 온달, 연오, 광개토대왕
- **40개 스테이지**: 4개 지역 × 10 스테이지 (난이도 점진적 상승)
- **4가지 요괴**: 도깨비, 귀신(벽돌 통과), 구미호(높은 HP), 이무기(느리지만 강력)
- **13×13 격자 맵**: 벽, 벽돌, 파워업 시스템
- **폭탄 및 폭발**: 3초 후 자동 폭발, 범위 파괴
- **파워업**: 속도 증가, 폭탄 개수 증가, 범위 증가
- **점수 시스템**: 적 처치 시 100점, 스테이지 보너스
- **저장 시스템**: 게임 진행 상태, 하이스코어, 게임 설정
- **광고**: Google Mobile Ads (배너, 전면, 보상형)
- **다국어**: 한국어, 영어 지원

## 📁 프로젝트 구조

```
lib/
├── main.dart                          # 앱 진입점
│
├── 🎮 game/                           # 게임 엔진 (Flame)
│   ├── bomberman_game.dart           # 메인 게임 클래스
│   ├── 🧩 components/                # 게임 컴포넌트
│   │   ├── player_component.dart    # 플레이어
│   │   ├── bomb_component.dart      # 폭탄 (3초 후 폭발)
│   │   ├── explosion_component.dart # 폭발 이펙트
│   │   ├── enemy_component.dart     # 일반 요괴 (도깨비, 귀신, 구미호, 이무기)
│   │   └── boss_component.dart      # 보스 요괴 (높은 HP, AI)
│   ├── 🗺️  map/                      # 게임 맵
│   │   ├── grid_map.dart            # 13×13 격자 맵
│   │   └── tile_type.dart           # 타일 (벽, 벽돌, 풀, 파워업)
│   └── 📊 data/                      # 게임 데이터
│       ├── character_data.dart      # 10가지 캐릭터
│       ├── stage_data.dart          # 40개 스테이지
│       └── enemy_data.dart          # 4가지 요괴
│
├── 🎨 screens/                        # UI 화면
│   ├── main_screen.dart             # 메인 화면
│   ├── game_screen.dart             # 게임 화면
│   ├── character_screen.dart        # 캐릭터 선택
│   ├── clear_screen.dart            # 스테이지 클리어
│   ├── gameover_screen.dart         # 게임 오버
│   └── settings_screen.dart         # 설정
│
├── ⚙️  managers/                      # 시스템 관리
│   ├── ad_manager.dart              # Google Mobile Ads
│   ├── save_manager.dart            # SharedPreferences
│   └── localization_manager.dart    # 한국어/영어
│
└── 🔧 utils/
    └── constants.dart               # 게임 상수

assets/
├── images/                           # 게임 이미지
│   ├── bg_region1.png              # 배경
│   ├── bg_region2.png
│   ├── bg_region3.png
│   ├── bg_region4.png
│   ├── char_*.png                  # 캐릭터 10개
│   ├── enemy_*.png                 # 요괴 4개
│   └── icon_*.png                  # UI 아이콘
├── sounds/                           # 효과음
│   ├── bgm_menu.mp3
│   ├── bgm_game.mp3
│   ├── sfx_bomb_place.wav
│   ├── sfx_explosion.wav
│   └── ...
├── i18n/                             # 다국어
│   ├── ko.json                     # 한국어
│   └── en.json                     # 영어
└── fonts/
    └── NotoSansKR-*.ttf
```

## 📦 필수 패키지

```yaml
dependencies:
  flutter: sdk: flutter
  flutter_localizations: sdk: flutter
  flame: ^1.17.0
  flame_audio: ^2.5.0
  google_mobile_ads: ^4.0.0
  in_app_purchase: ^3.1.10
  shared_preferences: ^2.2.2
  cupertino_icons: ^1.0.8
```

## 🚀 실행 방법

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run

# 릴리스 빌드
flutter build apk --release
```

## ✅ 완료된 항목

- ✅ 게임 구조 설계 (보버맨 게임 중심)
- ✅ 게임 컴포넌트 구현 (플레이어, 폭탄, 폭발, 요괴, 보스)
- ✅ 격자 맵 시스템 (13×13 타일)
- ✅ 게임 데이터 (10 캐릭터, 40 스테이지, 4 요괴)
- ✅ UI 화면 (메인, 캐릭터 선택, 게임, 클리어, 게임오버, 설정)
- ✅ 시스템 관리 (광고, 저장, 다국어)
- ✅ 다국어 JSON 파일 (한국어, 영어)
- ✅ pubspec.yaml 설정
- ✅ 프로젝트 구조 정리

## 🔄 다음 단계

- [ ] 게임 에셋 추가 (이미지, 음향 파일)
- [ ] Flame 게임 화면 구현
- [ ] 플레이어 입력 처리 (위/아래/좌/우/폭탄)
- [ ] 게임 로직 완성 (충돌 감지, 점수 계산)
- [ ] 테스트 및 디버깅
- [ ] Google Play 배포

## 🎯 게임 플레이 흐름

1. **메인 화면** → 게임 시작 / 캐릭터 선택 / 설정
2. **캐릭터 선택** → 10개 캐릭터 중 선택 (언락 시스템)
3. **게임 플레이** → 폭탄 설치 & 폭발로 요괴 처치
4. **스테이지 클리어** → 다음 스테이지 / 메뉴
5. **게임 오버** → 다시 시작 / 메뉴

## 📊 게임 밸런스

| 요소 | 값 |
|-----|-----|
| 맵 크기 | 13×13 타일 |
| 타일 크기 | 32px |
| 폭탄 폭발 시간 | 3초 |
| 폭발 효과 지속 시간 | 0.5초 |
| 기본 스코어 (적 처치) | 100점 |
| 스테이지 수 | 40개 |
| 캐릭터 수 | 10개 |
| 요괴 종류 | 4가지 |

## 🎨 색상 스킴

- **주요 색**: `#8B0000` (어두운 빨강)
- **강조 색**: `#FFD700` (금색)
- **배경**: `#1a1a1a` (검은색)
- **카드**: `#2d2d2d` (진회색)

---

**프로젝트 생성**: 2026-03-29
**최종 업데이트**: 2026-03-29
**버전**: 1.0.0 (개발 중)
