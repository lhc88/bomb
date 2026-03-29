# 봄버맨 게임 - 빠른 시작 가이드

## 🚀 게임 실행 방법

### 1. 의존성 설치
```bash
flutter pub get
```

### 2. 앱 실행
```bash
flutter run
```

### 3. 게임 플레이
- **메인 화면**: "게임 시작" 클릭
- **캐릭터 선택**: 원하는 캐릭터 선택
- **게임 화면**: D-pad와 폭탄 버튼으로 플레이

---

## 🎮 게임 조작

### 이동 (D-Pad)
```
    ↑
  ← ↓ →
```
- **↑**: 위로 이동
- **↓**: 아래로 이동
- **←**: 왼쪽 이동
- **→**: 오른쪽 이동

### 폭탄 (원형 버튼)
- **💣**: 폭탄 배치 (최대 폭탄 개수 제한)

---

## 🎯 게임 목표

1. **적 처치**: 모든 요괴를 폭탄으로 처치
2. **아이템 수집**: 부서진 벽에서 나온 아이템 획득
   - **속도 증가**: 이동 속도 증가
   - **폭탄 증가**: 동시 배치 폭탄 개수 증가
   - **범위 증가**: 폭발 범위 확대
3. **출구 도달**: 모든 적 처치 후 출구(금색 타일)에 도달

---

## ⚠️ 주의사항

### 피해 조건
- 자신의 폭탄 폭발에 맞으면 사망
- 적과 충돌하면 사망
- 시간 제한 초과 시 게임 오버

### 게임 메커니즘
- 폭탄은 **3초 후** 자동 폭발
- 폭발은 **0.5초 동안** 지속
- 부드러운 벽(갈색)은 파괴 가능
- 단단한 벽(회색)은 파괴 불가능
- 하드 벽은 폭발 범위를 차단

---

## 📊 게임 정보

### 점수 시스템
- **적 처치**: 100점
- **스테이지 보너스**: 1000점
- **시간 보너스**: 1초당 10점

### 스테이지 정보
- **스테이지**: 1~40
- **시간 제한**: 120초 (2분)
- **적 개수**: 스테이지마다 증가

### 캐릭터 능력치
- **속도**: 캐릭터별 이동 속도 (높을수록 빠름)
- **폭탄**: 동시 배치 가능한 최대 폭탄 개수
- **범위**: 폭탄 폭발의 최대 확산 범위 (타일 단위)

---

## 🔧 개발자 정보

### 핵심 파일 구조
```
lib/
├── game/
│   ├── bomberman_game.dart           # 메인 게임 로직
│   ├── components/
│   │   ├── player_component.dart     # 플레이어 제어
│   │   ├── bomb_component.dart       # 폭탄 시스템
│   │   ├── explosion_component.dart  # 폭발 효과
│   │   ├── enemy_component.dart      # 적 AI
│   │   └── boss_component.dart       # 보스 요괴
│   ├── map/
│   │   ├── grid_map.dart             # 게임 맵
│   │   └── tile_type.dart            # 타일 정의
│   └── data/
│       ├── character_data.dart       # 캐릭터 정보
│       ├── stage_data.dart           # 스테이지 정보
│       └── enemy_data.dart           # 적 정보
├── screens/
│   ├── main_screen.dart              # 메인 화면
│   ├── game_screen.dart              # 게임 화면
│   └── character_screen.dart         # 캐릭터 선택
└── utils/
    └── constants.dart                # 게임 상수
```

### 주요 클래스

#### BombermanGame
게임의 메인 로직을 담당합니다.
```dart
// 방향 입력 (D-pad)
gameInstance.handleDirectionInput(dirX, dirY);

// 폭탄 배치
gameInstance.handleBombInput();

// 게임 상태 확인
bool isPlaying = gameInstance.isPlaying;
bool isClear = gameInstance.isStageClear;
bool isOver = gameInstance.isGameOver;
```

#### PlayerComponent
플레이어 캐릭터를 제어합니다.
```dart
// 이동 시도
player.tryMove(dirX, dirY);

// 폭탄 배치
player.tryPlaceBomb();

// 아이템 수집
player.collectItem(itemType);

// 데미지 처리
player.takeDamage();
```

#### BombComponent
폭탄 시스템을 담당합니다.
```dart
// 폭탄 생성 시 자동으로 타이머 시작
// 3초 후 자동으로 폭발

// 폭발 콜백
onExplode: (centerX, centerY, fireRange) { ... }
```

#### ExplosionComponent
폭발 효과를 관리합니다.
```dart
// 영향을 받은 타일 확인
bool isAffected = explosion.isAffected(gridX, gridY);

// 자동으로 0.5초 후 제거됨
```

---

## 🐛 디버그 모드

### 디버그 정보 출력
```dart
gameInstance.printDebugInfo();
player.getDebugInfo();
bomb.getDebugInfo();
explosion.getDebugInfo();
```

### 그리드 맵 디버그
```dart
gridMap.printMapDebug();
```

---

## 📱 해상도 및 UI

### 게임 뷰포트
- **맵 크기**: 600x520 픽셀 (15x13 타일 × 40px)
- **카메라 줌**: 1.2x
- **배경색**: #1a1a1a (검은색)

### UI 레이아웃
- **우측 상단**: 점수, 폭탄, 적 정보
- **좌측 하단**: D-pad (40x40px 버튼)
- **우측 하단**: 폭탄 버튼 (60x60px)

---

## 💾 게임 저장

### SaveManager
게임 진행 상태를 저장합니다.
```dart
SaveManager().saveProgress(...);
SaveManager().loadProgress();
```

### 저장 항목
- 현재 스테이지
- 최고 점수
- 선택된 캐릭터
- 게임 설정

---

## 🌐 다국어 지원

### 지원 언어
- **한국어** (ko)
- **영어** (en)

### 로컬라이제이션 사용
```dart
final loc = LocalizationManager();
String text = loc.get('key_name');
```

---

## ❓ FAQ

**Q: 폭탄이 배치되지 않습니다.**
> 최대 폭탄 개수에 도달했는지 확인하세요. 아이템으로 폭탄 개수를 늘릴 수 있습니다.

**Q: 적이 보이지 않습니다.**
> 흰색 경계선 내 지도 범위를 확인하세요. 우측 상단 "남은 적" 표시가 0이 아닌지 확인하세요.

**Q: 화면이 반응하지 않습니다.**
> 게임 오버 또는 스테이지 클리어 상태입니다. 오버레이 버튼을 클릭하세요.

**Q: 저장이 되지 않습니다.**
> 게임 설정에서 저장 권한을 확인하세요.

---

## 📞 기술 지원

### 컴파일 오류
1. `flutter clean` 실행
2. `flutter pub get` 재실행
3. `flutter run` 다시 시도

### 런타임 오류
1. 콘솔 로그 확인
2. `printMapDebug()`, `printDebugInfo()` 호출
3. 문제 파일 식별 및 보고

---

**즐거운 게임 되세요!** 🎮
