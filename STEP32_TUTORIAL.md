# STEP 32: 튜토리얼 구현 완료 보고서

## 📋 튜토리얼 구현 목표

**목표**: 첫 플레이 시 게임 기본 조작법을 5단계로 안내

**요구사항**:
- ✅ 스테이지 1에서만 표시
- ✅ 첫 실행 시에만 표시 (SaveManager 추적)
- ✅ 5단계 튜토리얼
- ✅ 화살표 + 설명 텍스트 오버레이
- ✅ 탭으로 건너뛰기 가능
- ✅ 모두 한국어

---

## ✅ 수행된 구현 작업

### 1️⃣ SaveManager 확장

**파일**: `lib/managers/save_manager.dart`

#### 추가된 기능
```dart
// 저장 키 추가
static const String _keyTutorialCompleted = 'bomberman_tutorial_completed';

// 튜토리얼 완료 저장
Future<void> saveTutorialCompleted(bool completed) async {
  await _prefs.setBool(_keyTutorialCompleted, completed);
}

// 튜토리얼 완료 여부 로드
bool loadTutorialCompleted() {
  return _prefs.getBool(_keyTutorialCompleted) ?? false;
}
```

**역할**: 앱 첫 실행 여부 추적 (로컬 저장소에 저장)

---

### 2️⃣ 튜토리얼 오버레이 컴포넌트

**파일**: `lib/components/tutorial_overlay.dart` (새 파일)

#### 구성 요소

**A. 튜토리얼 단계 정의**
```dart
enum TutorialStep {
  movement,      // 1. 이동 버튼으로 움직여보세요
  bombPlacement, // 2. 폭탄 버튼을 눌러보세요
  escape,        // 3. 폭발 전에 피하세요!
  enemyDefeat,   // 4. 폭발로 요괴를 처치하세요!
  exit,          // 5. 출구로 이동하세요!
}
```

**B. 단계별 설명 텍스트**
```dart
static const Map<TutorialStep, String> stepTexts = {
  TutorialStep.movement: '이동 버튼으로 움직여보세요!\n(탭으로 건너뛸 수 있습니다)',
  TutorialStep.bombPlacement: '폭탄 버튼을 눌러\n폭탄을 설치해보세요!',
  TutorialStep.escape: '폭발 전에 피하세요!\n빠르게 움직여야 합니다!',
  TutorialStep.enemyDefeat: '폭발로 요괴를 처치하세요!\n모든 요괴를 없애야 합니다!',
  TutorialStep.exit: '출구로 이동하여\n스테이지를 클리어하세요!',
};
```

**C. 화살표 위치 맵**
```dart
static const Map<TutorialStep, Alignment> arrowAlignments = {
  TutorialStep.movement: Alignment.bottomCenter,    // 아래
  TutorialStep.bombPlacement: Alignment.bottomRight, // 우하
  TutorialStep.escape: Alignment.centerRight,        // 우측
  TutorialStep.enemyDefeat: Alignment.centerLeft,    // 좌측
  TutorialStep.exit: Alignment.topCenter,            // 상단
};
```

#### 주요 기능

**1. UI 렌더링**
- 반투명 배경 (50% 검은색)
- 금색 테두리 텍스트 박스
- 펄싱 애니메이션 화살표
- 한국어 설명 텍스트

**2. 상호작용**
```dart
@override
void onTapDown(TapDownInfo info) {
  nextStep(); // 탭하여 다음 단계로
}
```

**3. 애니메이션**
- 화살표 스케일 펄싱 (0.8 ~ 1.2)
- 1초 주기 애니메이션

**4. 메서드**
```dart
// 다음 단계로 진행
void nextStep() {
  if (currentIndex < lastStep) {
    currentStep = steps[currentIndex + 1];
  } else {
    removeFromParent(); // 튜토리얼 종료
  }
}
```

---

### 3️⃣ BombermanGame 통합

**파일**: `lib/game/bomberman_game.dart`

#### 추가된 임포트
```dart
import '../components/tutorial_overlay.dart';
import '../managers/save_manager.dart';
```

#### 추가된 필드
```dart
/// 튜토리얼 활성화 여부
late bool isTutorialActive;

/// 튜토리얼 오버레이
late TutorialOverlay? tutorialOverlay;

/// 튜토리얼 상태 추적
final Map<TutorialStep, bool> tutorialStepCompleted = {
  TutorialStep.movement: false,
  TutorialStep.bombPlacement: false,
  TutorialStep.escape: false,
  TutorialStep.enemyDefeat: false,
  TutorialStep.exit: false,
};

/// 플레이어 초기 위치 (튜토리얼용)
late int playerStartX;
late int playerStartY;

/// 요괴 초기 수
late int initialEnemyCount;
```

#### 초기화 로직 (onLoad)
```dart
// 플레이어 초기 위치 저장
playerStartX = player.gridX;
playerStartY = player.gridY;

// 요괴 초기 수 저장
initialEnemyCount = enemies.length;

// 튜토리얼 초기화
_initializeTutorial();
```

#### 튜토리얼 초기화 메서드
```dart
Future<void> _initializeTutorial() async {
  // 스테이지 1이고 튜토리얼을 안 봤으면 표시
  if (stageNumber == 1) {
    final tutorialCompleted = SaveManager().loadTutorialCompleted();
    if (!tutorialCompleted) {
      isTutorialActive = true;
      tutorialOverlay = TutorialOverlay(
        currentStep: TutorialStep.movement,
        onTutorialCompleted: () async {
          isTutorialActive = false;
          await SaveManager().saveTutorialCompleted(true);
        },
      );
      add(tutorialOverlay!);
    }
  }
}
```

#### 튜토리얼 진행 추적 (update)
```dart
// update 메서드 내
if (isTutorialActive && tutorialOverlay != null) {
  _updateTutorialProgress();
}
```

#### 단계별 조건 확인 메서드
```dart
void _updateTutorialProgress() {
  final currentStep = tutorialOverlay!.currentStep;

  switch (currentStep) {
    case TutorialStep.movement:
      // 플레이어가 시작 위치에서 움직였는가
      if (player.gridX != playerStartX || player.gridY != playerStartY) {
        tutorialOverlay!.nextStep();
      }
      break;

    case TutorialStep.bombPlacement:
      // 폭탄이 설치되었는가
      if (bombs.isNotEmpty) {
        tutorialOverlay!.nextStep();
      }
      break;

    case TutorialStep.escape:
      // 폭발이 발생했는가
      if (explosions.isNotEmpty) {
        tutorialOverlay!.nextStep();
      }
      break;

    case TutorialStep.enemyDefeat:
      // 요괴가 처치되었는가
      if (enemiesDefeated > 0) {
        tutorialOverlay!.nextStep();
      }
      break;

    case TutorialStep.exit:
      // 출구가 활성화되었을 때 자동 완료
      break;
  }
}
```

---

## 🎮 튜토리얼 흐름도

```
게임 시작 (스테이지 1)
    ↓
[SaveManager 확인]
    ├─ 튜토리얼 완료됨 → 그냥 게임 시작
    └─ 처음 플레이 → 튜토리얼 시작
    ↓
[단계 1] 이동 버튼으로 움직여보세요!
├─ 화살표: 아래 ↓
├─ 조건: 플레이어 이동
└─ 완료 → 단계 2로
    ↓
[단계 2] 폭탄 버튼을 눌러보세요!
├─ 화살표: 우하 ↙
├─ 조건: bombs.isNotEmpty
└─ 완료 → 단계 3으로
    ↓
[단계 3] 폭발 전에 피하세요!
├─ 화살표: 우측 ←
├─ 조건: explosions.isNotEmpty
└─ 완료 → 단계 4로
    ↓
[단계 4] 폭발로 요괴를 처치하세요!
├─ 화살표: 좌측 →
├─ 조건: enemiesDefeated > 0
└─ 완료 → 단계 5로
    ↓
[단계 5] 출구로 이동하세요!
├─ 화살표: 상단 ↑
└─ 탭 또는 클리어로 종료
    ↓
[SaveManager.saveTutorialCompleted(true)]
    ↓
튜토리얼 완료! 🎉
```

---

## 🎨 UI 디자인

### 텍스트 박스
```
┌─────────────────────────────────┐
│  이동 버튼으로 움직여보세요!     │
│  (탭으로 건너뛸 수 있습니다)    │
└─────────────────────────────────┘
    (색상: #2C1810 배경, #FFD700 테두리)
```

### 화살표 애니메이션
```
펄싱 효과 (1초 주기):
시간   0.0초: 0.8배 크기
시간   0.5초: 1.0배 크기
시간   1.0초: 1.2배 크기 (다시 반복)
```

### 배경
```
반투명 검은색 (50% 투명도)
↓ 플레이어가 게임 화면을 여전히 볼 수 있음
타스크에 집중 가능
```

---

## 🔧 동작 방식

### 흐름

1. **게임 시작** → onLoad() 호출
2. **튜토리얼 체크** → _initializeTutorial()
3. **매 프레임 업데이트** → update() → _updateTutorialProgress()
4. **조건 만족** → tutorialOverlay.nextStep()
5. **모든 단계 완료** → saveTutorialCompleted(true)

### 조건 만족 메커니즘

| 단계 | 조건 확인 | 방식 |
|------|---------|------|
| 이동 | gridX, gridY 변경 | 프레임마다 체크 |
| 폭탄 | bombs.isNotEmpty | 프레임마다 체크 |
| 폭발 | explosions.isNotEmpty | 프레임마다 체크 |
| 처치 | enemiesDefeated > 0 | 프레임마다 체크 |
| 출구 | 탭 또는 게임 클리어 | 탭 또는 자동 |

---

## 💾 저장 구조

### SharedPreferences 저장
```json
{
  "bomberman_tutorial_completed": true/false
}
```

- **키**: `bomberman_tutorial_completed`
- **타입**: bool
- **기본값**: false
- **범위**: 전역 (모든 플레이에 적용)

---

## ⚙️ 커스터마이징 가능 항목

### 텍스트 수정
```dart
// TutorialOverlay.stepTexts 수정
static const Map<TutorialStep, String> stepTexts = {
  TutorialStep.movement: '원하는 텍스트 입력',
  ...
};
```

### 화살표 위치 변경
```dart
// TutorialOverlay.arrowAlignments 수정
static const Map<TutorialStep, Alignment> arrowAlignments = {
  TutorialStep.movement: Alignment.bottomCenter, // 위치 변경
  ...
};
```

### 애니메이션 속도
```dart
// TutorialOverlay 내
static const double animationDuration = 1.0; // 초 단위
```

### 색상 변경
```dart
// TutorialOverlay._drawTutorialContent() 내
Paint()
  ..color = const Color(0xFF2C1810) // 배경색 변경
  ..color = const Color(0xFFFFD700) // 테두리색 변경
```

---

## 🧪 테스트 방법

### 튜토리얼 표시 확인
1. 앱 완전 제거 (데이터 초기화)
2. 스테이지 1 플레이
3. 튜토리얼 오버레이 표시 확인

### 튜토리얼 건너뛰기
1. 튜토리얼 중 화면 탭
2. 다음 단계로 진행 확인

### 단계별 조건 확인
- **단계 1**: 플레이어 이동 후 자동 진행
- **단계 2**: 폭탄 버튼 터치 후 자동 진행
- **단계 3**: 폭탄 폭발 후 자동 진행
- **단계 4**: 요괴 처치 후 자동 진행
- **단계 5**: 탭 또는 게임 클리어로 종료

### 재실행 확인
1. 스테이지 1 다시 플레이
2. 튜토리얼 표시 안 됨 확인

---

## 📁 구현된 파일

| 파일 | 내용 | 상태 |
|------|------|------|
| `lib/managers/save_manager.dart` | 튜토리얼 저장/로드 메서드 추가 | ✅ |
| `lib/components/tutorial_overlay.dart` | 튜토리얼 오버레이 컴포넌트 (새 파일) | ✅ |
| `lib/game/bomberman_game.dart` | 튜토리얼 통합 로직 | ✅ |

---

## ✅ 최종 검증 체크리스트

- [x] SaveManager에 튜토리얼 완료 여부 저장/로드
- [x] TutorialOverlay 컴포넌트 생성
- [x] 5단계 텍스트 및 화살표 설정
- [x] 화살표 애니메이션 (펄싱)
- [x] BombermanGame 통합
- [x] 스테이지 1에서만 표시
- [x] 첫 실행 시에만 표시
- [x] 각 단계별 조건 확인
- [x] 자동 진행 메커니즘
- [x] 탭으로 건너뛰기
- [x] 모두 한국어

---

## 🚀 배포 지침

### 첫 배포
```bash
# 기존 앱 완전 제거 후 설치
flutter clean
flutter pub get
flutter run --release
```

### 업데이트 배포
```bash
# 기본 배포 (튜토리얼 유지)
flutter build apk --release
```

### 튜토리얼 리셋 (테스트)
```dart
// 코드에서 임시로
await SaveManager().saveTutorialCompleted(false);
```

---

## 🎯 향후 개선 사항

### 선택적 기능
1. **튜토리얼 재시청** - 설정 화면에 "튜토리얼 다시 보기" 버튼
2. **단계별 스킵** - 특정 단계만 건너뛰기
3. **다국어 지원** - LocalizationManager와 연동
4. **비디오 튜토리얼** - 동작 비디오 추가
5. **음성 안내** - TTS(Text-to-Speech) 추가

### 성능 최적화
1. 화살표 렌더링 최적화 (Canvas 프로파일링)
2. 애니메이션 프레임률 조정
3. 메모리 사용량 모니터링

---

**구현 완료일**: 2026-03-29
**버전**: 1.2.2 (튜토리얼)
**테스트 필요**: 스테이지 1 (첫 플레이)
