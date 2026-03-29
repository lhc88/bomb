# 게임 상수 (Constants) 가이드

## 📋 GameConstants 클래스 구조

### 1️⃣ 앱 정보 (App Info)
```dart
static const String appName = '신시 봄버맨';
static const String packageName = 'com.sinsi.bomberman';
static const String version = '1.0.0';
```

### 2️⃣ 게임판 설정 (Grid Settings)
```dart
static const int gridWidth = 15;              // 격자 너비 (가로)
static const int gridHeight = 13;             // 격자 높이 (세로)
static const double tileSize = 40.0;          // 타일 크기 (픽셀)

// 계산된 값
static const double mapWidth = 600.0;         // 15 * 40 = 600px
static const double mapHeight = 520.0;        // 13 * 40 = 520px
```

### 3️⃣ 플레이어 설정 (Player Settings)
```dart
static const double defaultPlayerSpeed = 120.0;  // 이동 속도 (픽셀/초)
static const int defaultBombCount = 1;           // 기본 폭탄 개수
static const int defaultFireRange = 2;           // 기본 폭발 범위 (타일)
```

### 4️⃣ 폭탄 및 폭발 (Bomb & Explosion)
```dart
static const double bombExplosionDelay = 3.0;     // 폭발 지연 시간 (초)
static const double explosionDuration = 0.5;      // 폭발 효과 지속 시간
static const double bombBlinkInterval = 0.2;      // 폭탄 깜빡임 간격
```

### 5️⃣ 스테이지 설정 (Stage Settings)
```dart
static const int totalStages = 40;           // 총 스테이지 수
static const int stagesPerRegion = 10;       // 지역당 스테이지 수
static const int totalRegions = 4;           // 총 지역 수
static const int stageTimeLimit = 120;       // 스테이지 제한 시간 (초)
```

### 6️⃣ 캐릭터 설정 (Character Settings)
```dart
static const int totalCharacters = 10;              // 총 캐릭터 수
static const int defaultActiveCharacters = 2;      // 처음 사용 가능 캐릭터 수
```

### 7️⃣ 요괴 설정 (Enemy Settings)
```dart
static const int totalEnemyTypes = 4;           // 요괴 종류 수
static const int minEnemiesPerStage = 3;        // 스테이지당 최소 요괴 수
static const int maxEnemiesPerStage = 10;       // 스테이지당 최대 요괴 수

// 요괴별 이동 속도 배수
static const Map<int, double> enemySpeedMultiplier = {
  1: 0.8,   // 도깨비 (80% 속도)
  2: 1.2,   // 귀신 (120% 속도)
  3: 1.0,   // 구미호 (100% 속도)
  4: 0.6,   // 이무기 (60% 속도)
};

// 요괴별 기본 HP
static const Map<int, int> enemyHpMap = {
  1: 1,     // 도깨비
  2: 1,     // 귀신
  3: 2,     // 구미호
  4: 3,     // 이무기
};
```

### 8️⃣ 게임 플레이 (Gameplay)
```dart
static const int scorePerEnemy = 100;        // 적 처치 시 점수
static const int baseStageScore = 1000;      // 스테이지 클리어 기본 점수
static const int timeBonus = 10;             // 시간 보너스 (1초당)
```

### 9️⃣ 파워업 설정 (PowerUp Settings)
```dart
// 파워업 확률
static const double speedUpProbability = 0.10;    // 속도 증가 (10%)
static const double bombUpProbability = 0.10;     // 폭탄 증가 (10%)
static const double fireUpProbability = 0.10;     // 범위 증가 (10%)

// 파워업 효과
static const double speedBoost = 40.0;      // 속도 증가량 (40px/초)
static const int bombCountBoost = 1;        // 폭탄 증가량 (1개)
static const int fireRangeBoost = 1;        // 범위 증가량 (1타일)
```

### 🔟 색상 팔레트 (Color Palette)
```dart
// Hex 문자열
static const String primaryColorHex = '#8B0000';      // 진홍색
static const String accentColorHex = '#B8860B';       // 금색
static const String backgroundColorHex = '#2C1810';   // 진갈색

// Color 객체
static const Color primaryColor = Color(0xFF8B0000);      // 진홍색
static const Color accentColor = Color(0xFFB8860B);       // 금색
static const Color backgroundColor = Color(0xFF2C1810);   // 진갈색
static const Color uiBackground = Color(0xFF1a1a1a);      // UI 배경 (검은색)
static const Color cardColor = Color(0xFF2d2d2d);         // UI 카드 (진회색)
static const Color textColor = Color(0xFFFFFFFF);         // 텍스트 (흰색)
static const Color explosionColor = Color(0xFFFF6B35);    // 폭발 이펙트 (주황색)
static const Color successColor = Color(0xFF4CAF50);      // 성공 (초록색)
static const Color failureColor = Color(0xFFF44336);      // 실패 (빨강색)
```

## 📊 게임판 크기 계산

### 총 크기
```
너비: 15 타일 × 40px = 600px
높이: 13 타일 × 40px = 520px
```

### 스폰 포인트
- **좌상단**: (1, 1)
- **우상단**: (13, 1)
- **좌하단**: (1, 11)
- **우하단**: (13, 11)

## 🎯 요괴 통계

| 요괴 | ID | 속도 배수 | HP | 점수 |
|------|----|---------|----|------|
| 도깨비 | 1 | 0.8x (96px/초) | 1 | 100 |
| 귀신 | 2 | 1.2x (144px/초) | 1 | 150 |
| 구미호 | 3 | 1.0x (120px/초) | 2 | 200 |
| 이무기 | 4 | 0.6x (72px/초) | 3 | 300 |

## 🎨 색상 코드

| 이름 | Hex | RGB |
|------|-----|-----|
| 진홍색 (Primary) | #8B0000 | (139, 0, 0) |
| 금색 (Accent) | #B8860B | (184, 134, 11) |
| 진갈색 (Background) | #2C1810 | (44, 24, 16) |
| 검은색 (UI BG) | #1a1a1a | (26, 26, 26) |
| 진회색 (Card) | #2d2d2d | (45, 45, 45) |

## 📚 사용 예제

### GameConstants 사용
```dart
import 'utils/constants.dart';

// 격자 크기 사용
double mapWidth = GameConstants.mapWidth;  // 600.0
int gridWidth = GameConstants.gridWidth;   // 15
double tileSize = GameConstants.tileSize;  // 40.0

// 폭탄 설정
double bombTime = GameConstants.bombExplosionDelay;  // 3.0
int bombCount = GameConstants.defaultBombCount;     // 1
int fireRange = GameConstants.defaultFireRange;     // 2

// 색상 사용
Color primaryColor = GameConstants.primaryColor;    // Color(0xFF8B0000)
Color accentColor = GameConstants.accentColor;      // Color(0xFFB8860B)
```

### Enum 사용
```dart
import 'utils/constants.dart';

// 게임 상태
GameState state = GameState.playing;

// 지역
Region region = Region.humanWorld;
print(regions[0].koreanName);  // "인간계"
```

### 에셋 사용
```dart
import 'utils/constants.dart';

// 사운드
String bgm = SoundAssets.bgmGame;
String sfx = SoundAssets.sfxExplosion;

// 이미지
String charImage = ImageAssets.charDangun;
String enemyImage = ImageAssets.enemyGoblin;
String bombImage = ImageAssets.bomb;
```

## 🔄 GridMap에서의 사용

GridMap은 GameConstants를 자동으로 사용합니다:

```dart
import 'constants.dart';

class GridMap {
  static const int width = GameConstants.gridWidth;   // 15
  static const int height = GameConstants.gridHeight; // 13
  static const double tileSize = GameConstants.tileSize; // 40.0
}
```

---

**파일 위치**: `lib/utils/constants.dart`  
**작성일**: 2026-03-29  
**마지막 업데이트**: 2026-03-29
