# STEPS 23-25: 모던 비주얼, 사운드 시스템, UI 완성 보고서

## 📋 개요

게임의 비주얼을 현대화하고, 완전한 사운드 시스템을 구축하며, 모든 UI 화면을 완성했습니다.

---

## ✅ STEP 23: 모던 비주얼 적용

### 1. GameColors 상수 클래스 생성

#### 위치
- `lib/game/constants/game_colors.dart`

#### 색상 팔레트 정의

**배경색 (2개)**
- `background`: #2C1810 (어두운 갈색) - 게임 배경
- `darkBackground`: #1a1a1a (매우 어두운 회색) - UI 배경

**벽 색상 (3개)**
- `solidWall`: #4A2810 (단단한 벽)
- `softWall`: #8B4513 (부드러운 벽)
- `emptySpace`: #3A2010 (빈 공간)
- `checkPattern`: #4A3020 (체크 패턴)

**UI 색상 (5개)**
- `primary`: #8B0000 (진홍색) - AppBar, 주요 강조
- `accent`: #FFD700 (금색) - 강조, 테두리
- `success`: #4CAF50 (초록색) - 성공, 확인
- `danger`: #FF6B6B (빨강) - 경고, 위험
- `warning`: #FF9800 (주황색) - 알림

**텍스트 색상 (3개)**
- `textPrimary`: #FFFFFF (흰색)
- `textSecondary`: #BBBBBB (밝은 회색)
- `textDisabled`: #666666 (어두운 회색)

**폭탄 색상 (3개)**
- `bombBody`: #1A1A1A (검정 본체)
- `bombFuse`: #FF2020 (빨간 도화선)
- `bombLight`: #FFFF00 (노란 불빛)

**화염 색상 (그라데이션)**
- `flameStart`: #FF6600 (주황)
- `flameEnd`: #FFD700 (금색)

**플레이어 캐릭터 색상 (9개)**
- `playerDefault`: #4CAF50
- `playerBari`: #E91E63 (분홍)
- `playerJumong`: #2196F3 (파랑)
- `playerSondok`: #9C27B0 (보라)
- `playerUlji`: #FF9800 (주황)
- `playerYeonorang`: #00BCD4 (청록)
- `playerOndal`: #795548 (갈색)
- `playerGwanggaeto`: #FF5722 (빨강)
- `playerHwanung`: #FFEB3B (노랑)
- `playerDangun`: #4A90E2 (진파랑)

**요괴 색상 (4개, 한국 신화 컬러)**
- `enemyGoblin`: #8B0000 (진홍)
- `enemyGumiho`: #FF6B9D (연분홍)
- `enemyImugi`: #1A472A (짙은 녹색)
- `enemyTenma`: #6A5ACD (보라)

**아이템 색상 (6개)**
- `itemFireUp`: #FF6600 (주황)
- `itemBombUp`: #1A1A1A (검정)
- `itemSpeedUp`: #00FF00 (초록)
- `itemTimeExtend`: #0099FF (파랑)
- `itemShield`: #FFD700 (금색)
- `itemCurse`: #800080 (보라)

**카드 색상 (3개)**
- `cardBackground`: #2d2d2d
- `cardBorder`: #444444
- `cardHighlight`: #FFD700

**상태 색상 (3개)**
- `hpFull`: #4CAF50 (초록)
- `hpHalf`: #FFD700 (금색)
- `hpCritical`: #FF6B6B (빨강)

### 2. 모던 비주얼 적용

#### 적용된 효과

1. **그림자 효과 (Text Shadow)**
   ```dart
   shadows: [
     Shadow(
       color: Colors.black.withValues(alpha: 0.7),
       offset: const Offset(2, 2),
       blurRadius: 4,
     ),
   ]
   ```

2. **둥근 모서리 (RoundedRectangleBorder)**
   ```dart
   BorderRadius.circular(16)  // 모든 버튼, 카드
   ```

3. **테두리 강조 (Border)**
   ```dart
   border: Border.all(
     color: GameColors.accent,
     width: 2,
   )
   ```

4. **높이 효과 (Elevation & Shadow)**
   ```dart
   elevation: 8,
   shadowColor: Colors.black.withValues(alpha: 0.5),
   ```

5. **글로우 효과 (Box Shadow with Glow)**
   ```dart
   boxShadow: [
     BoxShadow(
       color: GameColors.accent.withValues(alpha: 0.3),
       blurRadius: 12,
       spreadRadius: 2,
     ),
   ]
   ```

---

## ✅ STEP 24: 사운드 시스템

### 1. SoundManager 구현

#### 위치
- `lib/managers/sound_manager.dart`

#### 주요 기능

**싱글톤 패턴**
```dart
static final SoundManager _instance = SoundManager._internal();
factory SoundManager() => _instance;
```

**초기화**
```dart
Future<void> initialize() async {
  // SaveManager에서 설정 로드
  // FlameAudio 초기화
}
```

### 2. 효과음 목록 (8개)

| 효과음 | 파일명 | 설명 |
|--------|--------|------|
| 폭탄 설치 | `bomb_place.wav` | 플레이어가 폭탄 설치 |
| 폭발 | `explosion.wav` | 폭탄 폭발음 + 진동 |
| 벽 파괴 | `wall_break.wav` | 부드러운 벽 파괴 |
| 아이템 획득 | `item_get.wav` | 아이템 수집 + 진동 |
| 플레이어 사망 | `player_death.wav` | 플레이어 죽음 + 강진동 |
| 요괴 처치 | `enemy_death.wav` | 요괴 처치 + 진동 |
| 스테이지 클리어 | `stage_clear.wav` | 클리어 축하음 + 진동 |
| 보스 등장 | `boss_appear.wav` | 보스 등장 연출 + 강진동 |

**BGM**
| BGM | 파일명 | 설명 |
|-----|--------|------|
| 루프 음악 | `bgm_loop.mp3` | 게임 플레이 배경음 (루프) |

### 3. API

**효과음 재생**
```dart
await SoundManager().playBombPlace();
await SoundManager().playExplosion();
await SoundManager().playWallBreak();
await SoundManager().playItemGet();
await SoundManager().playPlayerDeath();
await SoundManager().playEnemyDeath();
await SoundManager().playStageClear();
await SoundManager().playBossAppear();
```

**BGM 관리**
```dart
await SoundManager().playBGM();      // 시작
await SoundManager().stopBGM();      // 중지
await SoundManager().pauseBGM();     // 일시정지
await SoundManager().resumeBGM();    // 재개
```

**진동 피드백**
```dart
await SoundManager().vibrate(duration: 100, intensity: 100);
await SoundManager().vibrateLight();   // 가벼운 진동
await SoundManager().vibrateHeavy();   // 강한 진동
```

**설정 토글**
```dart
await SoundManager().toggleSound();     // 효과음 on/off
await SoundManager().toggleMusic();     // BGM on/off
await SoundManager().toggleVibration(); // 진동 on/off
```

### 4. SaveManager 연동

모든 설정은 SaveManager를 통해 자동 저장됩니다:
```dart
// 초기화 시
final settings = SaveManager().loadGameSettings();
_soundEnabled = settings['sound'] ?? true;
_musicEnabled = settings['music'] ?? true;
_vibrationEnabled = settings['vibration'] ?? true;

// 변경 시
await SaveManager().saveGameSettings(
  soundEnabled: _soundEnabled,
  musicEnabled: _musicEnabled,
  vibrationEnabled: _vibrationEnabled,
);
```

---

## ✅ STEP 25: UI 화면 완성

### 1. 메인 화면 (MainScreen)

#### 개선 사항

**타이틀**
- 크기: 56px (기존 48px)
- 색상: GameColors.primary (진홍색)
- 효과: 텍스트 그림자, 글자 간격 2px
- 자막 색상: GameColors.accent (금색)

**하이스코어 표시**
- 배경: 진하고 어두운 카드
- 테두리: 금색 2px
- 그림자: 금색 그로우 효과
- 아이콘: 👑 (왕관)
- 서식: 중앙 정렬, 큰 텍스트

**버튼 스타일**
- 색상: GameColors.primary (진홍색)
- 테두리: GameColors.accent (금색 2px)
- 모서리: 16px 둥근 모서리
- 높이 효과: elevation 8
- 상호작용: 클릭 시 진동 + 시각 피드백
- 텍스트: 화이트, 크기 20px, 글자 간격 1px

### 2. 스테이지 클리어 화면 (ClearScreen)

#### 개선 사항

**타이틀**
- 텍스트: "스테이지 클리어!"
- 색상: GameColors.success (초록색)
- 크기: 48px
- 효과: 초록색 그로우 그림자
- 글자 간격: 2px

**정보 카드**
- 배경: GameColors.cardBackground
- 테두리: GameColors.accent (금색 2px)
- 모서리: 16px
- 그림자: 검정색 반투명

**별점 표시**
- 클리어 시간 기반으로 1~3개 별 표시
- ⭐ 완성된 별
- ☆ 빈 별

**버튼**
- 다음 스테이지: GameColors.success (초록색)
- 재도전: GameColors.warning (주황색)
- 메인: GameColors.primary (진홍색)

### 3. 게임오버 화면 (GameOverScreen)

#### 개선 사항

**타이틀**
- 텍스트: "게임 오버"
- 색상: GameColors.danger (빨강)
- 크기: 56px
- 효과: 빨강색 그로우 그림자 (16px 블러)
- 글자 간격: 2px

**정보 카드**
- 배경: GameColors.cardBackground
- 테두리: GameColors.danger (빨강 2px)
- 모서리: 16px
- 그림자: 검정색 반투명

**버튼**
- 다시 시작: GameColors.success (초록색)
- 메인으로: GameColors.primary (진홍색)

**부활 옵션** (구현 준비)
- 광고 시청 후 부활 (스테이지당 1회)

### 4. 캐릭터 선택 화면 (CharacterScreen)

#### 개선 사항

**배경**: GameColors.background (어두운 갈색)
**AppBar**: GameColors.primary (진홍색)
**선택 버튼**: GameColors.success (초록색)

### 5. 게임 HUD (InGameHUD)

#### 개선 사항

**상단 바**
- 배경: 반투명 검정 (opacity 0.5)
- 텍스트: 화이트
- 점수: GameColors.accent (금색), 크기 18px

**시간 표시**
- 일반: 반투명 검정
- 경고 (≤30초): GameColors.danger (빨강)
- 테두리: 2px

**아이템 표시**
- 배경: 반투명 검정 (opacity 0.6)
- 테두리: GameColors.accent (금색)
- 모서리: 8px

---

## 📊 색상 적용 현황

### 적용된 화면
- ✅ MainScreen: 배경, 타이틀, 버튼, 하이스코어
- ✅ ClearScreen: 배경, 타이틀, 카드, 버튼
- ✅ GameOverScreen: 배경, 타이틀, 카드, 버튼
- ✅ CharacterScreen: 배경, AppBar, 버튼
- ✅ StageSelectionScreen: 배경, AppBar
- ✅ SettingsScreen: 배경, AppBar
- ✅ InGameHUD: 배경, 텍스트, 경고, 아이템

### 추가 가능한 효과
1. 🎨 **파티클 이펙트**: 폭발 시 파티클 애니메이션
2. ✨ **반짝임 효과**: 아이템 획득 시 반짝임
3. 👻 **잔상 효과**: 연오랑 캐릭터 이동 시 잔상

---

## 🔧 구현 상세

### GameColors 사용 예시

```dart
// 1. 배경색
backgroundColor: GameColors.background

// 2. 버튼 색상
backgroundColor: GameColors.primary

// 3. 강조 색상
color: GameColors.accent

// 4. 반투명 색상
color: GameColors.blackTransparent(0.5)

// 5. 카드 스타일
decoration: BoxDecoration(
  color: GameColors.cardBackground,
  border: Border.all(color: GameColors.accent, width: 2),
  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5))],
)
```

### SoundManager 사용 예시

```dart
// 효과음 재생
await SoundManager().playExplosion();

// BGM 시작
await SoundManager().playBGM();

// 진동 피드백
await SoundManager().vibrateLight();

// 설정 변경
await SoundManager().toggleSound();
```

---

## ✅ 테스트 체크리스트

- [x] GameColors 상수 클래스 생성
- [x] 모든 화면에 배경색 적용
- [x] 모든 화면에 AppBar 색상 적용
- [x] 타이틀 텍스트 그림자 효과
- [x] 버튼 테두리 및 높이 효과
- [x] 카드 그로우 그림자
- [x] SoundManager 싱글톤 구현
- [x] 효과음 재생 메서드 (8개)
- [x] BGM 관리 메서드
- [x] 진동 피드백 통합
- [x] SaveManager 연동
- [x] 메인 화면 UI 완성
- [x] 클리어 화면 UI 완성
- [x] 게임오버 화면 UI 완성
- [x] HUD 색상 업데이트

---

## 📁 생성/수정 파일

### 신규 생성 (2개)
- `lib/game/constants/game_colors.dart` - 색상 상수 정의
- `lib/managers/sound_manager.dart` - 사운드 관리

### 수정된 파일 (8개)
- `lib/screens/main_screen.dart`
- `lib/screens/clear_screen.dart`
- `lib/screens/gameover_screen.dart`
- `lib/screens/character_screen.dart`
- `lib/screens/stage_selection_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/components/in_game_hud.dart`

---

## 🎵 사운드 파일 다운로드 안내

다음 사이트에서 무료로 사운드 효과음을 다운로드할 수 있습니다:

### Freesound.org
- **bomb_place.wav**: "Button Click" 또는 "Pop" 효과음
- **explosion.wav**: "Explosion" 또는 "Boom" 효과음
- **wall_break.wav**: "Break" 또는 "Crack" 효과음
- **item_get.wav**: "Coin" 또는 "Power-up" 효과음
- **player_death.wav**: "Lose" 또는 "Game Over" 효과음
- **enemy_death.wav**: "Enemy Down" 또는 "Defeat" 효과음
- **stage_clear.wav**: "Victory" 또는 "Success" 효과음
- **boss_appear.wav**: "Boss Theme" 또는 "Alert" 효과음
- **bgm_loop.mp3**: "Background Music" 또는 "Game Music" (루프 가능)

### 다운로드 후
1. `assets/sounds/` 폴더에 파일 저장
2. `pubspec.yaml`에 에셋 등록 (이미 등록됨)
3. `SoundManager().initialize()` 호출 시 자동 로드

---

## 🎨 시각적 개선 요약

| 항목 | 이전 | 현재 |
|------|------|------|
| 배경색 | #1a1a1a | #2C1810 (모던 갈색) |
| 타이틀 색상 | 금색 | 진홍색 + 그림자 |
| 버튼 색상 | 기본 | 진홍색 + 금색 테두리 |
| 모서리 | 12px | 16px (더 둥금) |
| 효과 | 없음 | 그림자, 테두리, 글로우 |
| 텍스트 | 기본 | 글자 간격 + 그림자 |

---

## 🚀 성능 영향

- **색상 상수**: 메모리 미미 (<1KB)
- **SoundManager**: 싱글톤으로 인스턴스 1개만 유지
- **시각 효과**: GPU 가속으로 성능 무시 가능

---

**구현 완료일**: 2026-03-29
**버전**: 1.2.0 (모던 비주얼 + 사운드 시스템 + UI 완성)
