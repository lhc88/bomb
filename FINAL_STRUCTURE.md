# 신시 봄버맨 - 최종 프로젝트 구조

## 📊 완성된 프로젝트 개요

**프로젝트명**: 신시 봄버맨 (Sinsi Bomber)  
**게임 장르**: 2D 봄버맨 (타일 기반)  
**개발 엔진**: Flame (Flutter 게임 엔진)  
**총 파일 수**: 21개 Dart + 2개 JSON  
**코드량**: ~2,800줄  

## 📁 최종 폴더 구조

```
bomberman/
│
├── lib/
│   ├── main.dart                              (1개)
│   │
│   ├── game/                                  (10개)
│   │   ├── bomberman_game.dart
│   │   ├── components/
│   │   │   ├── player_component.dart
│   │   │   ├── bomb_component.dart
│   │   │   ├── explosion_component.dart
│   │   │   ├── enemy_component.dart
│   │   │   └── boss_component.dart
│   │   ├── map/
│   │   │   ├── grid_map.dart
│   │   │   └── tile_type.dart
│   │   └── data/
│   │       ├── character_data.dart
│   │       ├── stage_data.dart
│   │       └── enemy_data.dart
│   │
│   ├── screens/                               (6개)
│   │   ├── main_screen.dart
│   │   ├── game_screen.dart
│   │   ├── character_screen.dart
│   │   ├── clear_screen.dart
│   │   ├── gameover_screen.dart
│   │   └── settings_screen.dart
│   │
│   ├── managers/                              (3개)
│   │   ├── ad_manager.dart
│   │   ├── save_manager.dart
│   │   └── localization_manager.dart
│   │
│   └── utils/                                 (1개)
│       └── constants.dart
│
├── assets/
│   ├── images/                                (📁 플레이스홀더)
│   │   ├── bg_region*.png
│   │   ├── char_*.png
│   │   ├── enemy_*.png
│   │   └── icon_*.png
│   │
│   ├── sounds/                                (📁 플레이스홀더)
│   │   ├── bgm_menu.mp3
│   │   ├── bgm_game.mp3
│   │   └── sfx_*.wav
│   │
│   ├── i18n/                                  (2개)
│   │   ├── ko.json                           (한국어)
│   │   └── en.json                           (영어)
│   │
│   └── fonts/                                 (📁 플레이스홀더)
│       └── NotoSansKR-*.ttf
│
├── android/                                   (구성 완료)
│   └── app/
│       └── build.gradle.kts (API 21 설정)
│
├── pubspec.yaml                               (모든 의존성 설정)
├── README.md                                  (프로젝트 설명)
├── PROJECT_STRUCTURE.md                       (구조 설명)
└── FINAL_STRUCTURE.md                         (이 파일)
```

## 📊 파일 통계

| 폴더 | 파일 수 | 라인 수 | 설명 |
|------|--------|--------|------|
| **lib/** | 21 | ~2,800 | Dart 소스 코드 |
| **assets/i18n/** | 2 | ~350 | 다국어 JSON |
| **총합** | 23 | ~3,150 | 모든 코드 |

### 상세 분석

#### Game (10개)
- `bomberman_game.dart` (150줄) - 게임 메인 클래스
- **Components** (5개, 280줄)
  - PlayerComponent (70줄) - 플레이어 조작
  - BombComponent (60줄) - 폭탄 물리
  - ExplosionComponent (90줄) - 폭발 이펙트
  - EnemyComponent (70줄) - 요괴 AI
  - BossComponent (90줄) - 보스 AI
- **Map** (2개, 120줄)
  - GridMap (90줄) - 13×13 맵 시스템
  - TileType (30줄) - 타일 정의
- **Data** (3개, 250줄)
  - CharacterData (80줄) - 10 캐릭터
  - StageData (120줄) - 40 스테이지
  - EnemyData (50줄) - 4 요괴

#### Screens (6개, 900줄)
- MainScreen (180줄) - 메인 메뉴
- GameScreen (120줄) - 게임 화면
- CharacterScreen (150줄) - 캐릭터 선택
- ClearScreen (180줄) - 클리어 화면
- GameOverScreen (180줄) - 게임오버
- SettingsScreen (210줄) - 설정

#### Managers (3개, 450줄)
- AdManager (150줄) - Google Mobile Ads
- SaveManager (180줄) - 저장 시스템
- LocalizationManager (120줄) - 다국어

#### Utils (1개, 150줄)
- Constants (150줄) - 게임 상수

## 🎮 게임 요소

### 10가지 캐릭터
```
1. 단군 (기본)          속도: 120, 폭탄: 1, 범위: 2
2. 환웅 (기본)          속도: 140, 폭탄: 1, 범위: 2
3. 주몽                 속도: 100, 폭탄: 3, 범위: 2
4. 바리데기             속도: 110, 폭탄: 1, 범위: 4
5. 유리                 속도: 160, 폭탄: 1, 범위: 2
6. 선덕여왕             속도: 100, 폭탄: 2, 범위: 3
7. 을지문덕             속도: 120, 폭탄: 2, 범위: 2
8. 온달                 속도: 80,  폭탄: 1, 범위: 5
9. 연오                 속도: 130, 폭탄: 2, 범위: 1
10. 광개토대왕          속도: 125, 폭탄: 2, 범위: 3
```

### 4가지 요괴
```
1. 도깨비 (기본)        HP: 1, 속도: 80,  점수: 100
2. 귀신 (벽 통과)       HP: 1, 속도: 120, 점수: 150
3. 구미호 (높은 HP)     HP: 2, 속도: 100, 점수: 200
4. 이무기 (강력)        HP: 3, 속도: 60,  점수: 300
```

### 40개 스테이지 (4개 지역)
```
지역 1: 인간계 (스테이지 1-10)
지역 2: 요괴계 (스테이지 11-20)
지역 3: 용계 (스테이지 21-30)
지역 4: 신계 (스테이지 31-40)

각 지역마다 난이도 점진적 상승
10번 스테이지마다 보스 등장
```

### 게임 맵
```
13×13 격자 (416×416px)
- 벽: 부술 수 없음
- 벽돌: 폭탄으로 부술 수 있음
- 풀: 이동 가능
- 파워업: 속도↑, 폭탄↑, 범위↑
```

## 🔧 시스템 기능

### AdManager
- Google Mobile Ads SDK 통합
- 배너 광고 (화면 하단)
- 전면 광고 (보스 스테이지)
- 보상형 광고 (골드 2배)

### SaveManager
- SharedPreferences 기반
- 게임 진행 상태 저장/로드
- 하이스코어 관리
- 게임 설정 저장
- 언락된 캐릭터 기록

### LocalizationManager
- 한국어 / 영어 지원
- JSON 기반 번역
- 동적 텍스트 치환 {변수}

## 📱 Android 설정

```gradle
- API 21 (Android 5.0)
- minSdk: 21
- compileSdk: 34
- 필수 권한: INTERNET, ACCESS_NETWORK_STATE
```

## 🎨 UI 디자인

### 색상
- 주요: `#8B0000` (어두운 빨강, 신화 테마)
- 강조: `#FFD700` (금색)
- 배경: `#1a1a1a` (검은색)
- 카드: `#2d2d2d` (진회색)

### 화면 구성
- 메인 화면: 게임 시작, 캐릭터 선택, 설정
- 캐릭터 화면: 2열 그리드 (10개 캐릭터)
- 게임 화면: 게임 영역 (좌측) + 정보 패널 (우측)
- 결과 화면: 점수, 적 처치 수, 소요 시간

## 📚 다국어 지원

### 한국어 (ko.json)
```json
{
  "main": {
    "title": "신시 봄버맨",
    "subtitle": "신시의 요괴를 무찌르세요!"
  },
  "buttons": {
    "start_game": "게임 시작",
    ...
  }
}
```

### 영어 (en.json)
```json
{
  "main": {
    "title": "Sinsi Bomber",
    "subtitle": "Defeat the monsters of Sinsi!"
  },
  "buttons": {
    "start_game": "Start Game",
    ...
  }
}
```

## 🚀 다음 단계

### 긴급 (게임 실행 필수)
- [ ] 게임 이미지 에셋 추가
- [ ] Flame 게임 화면 구현
- [ ] 플레이어 입력 처리

### 필수
- [ ] 게임 로직 완성
- [ ] 충돌 감지 구현
- [ ] 점수 계산 시스템

### 선택
- [ ] 음향 효과 추가
- [ ] 배경음악 추가
- [ ] 파티클 이펙트
- [ ] 애니메이션 강화

### 배포
- [ ] 테스트 및 디버깅
- [ ] Google Play 등록
- [ ] 앱 배포

## 📦 의존성

```yaml
flutter: 3.41.5
dart: 3.11.3

dependencies:
  flame: ^1.17.0
  flame_audio: ^2.5.0
  google_mobile_ads: ^4.0.0
  in_app_purchase: ^3.1.10
  shared_preferences: ^2.2.2
  cupertino_icons: ^1.0.8
```

## ✅ 완료 체크리스트

- ✅ 프로젝트 구조 설계
- ✅ 21개 Dart 파일 작성
- ✅ 2개 i18n JSON 파일
- ✅ 게임 컴포넌트 구현
- ✅ UI 화면 6개
- ✅ 시스템 매니저 3개
- ✅ 게임 데이터 완성
- ✅ pubspec.yaml 설정
- ✅ Android 설정
- ✅ 다국어 지원
- ✅ 광고 통합
- ✅ 저장 시스템
- ✅ 상수 정의

---

**생성일**: 2026-03-29  
**최종 업데이트**: 2026-03-29  
**상태**: ✅ 프로젝트 구조 완성 (로직 구현 진행 중)
