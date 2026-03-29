# STEP 19: 스테이지 진행 UI & 게임 HUD 완료 보고서

## 📋 개요

게임의 스테이지 선택 화면과 게임 중 상태 표시 HUD가 완성되었습니다.

---

## ✅ STEP 19: 스테이지 진행 UI

### 1. 스테이지 선택 화면 (StageSelectionScreen)

#### 화면 구성

```
┌─────────────────────────────────────────────┐
│       [AppBar: 스테이지 선택]                │
├─────────────────────────────────────────────┤
│  월드 탭:  [🏯 인간계] [👹 요괴계] [🐉 용계] [✨ 신계]  │
├─────────────────────────────────────────────┤
│                                             │
│  스테이지 그리드 (5열)                       │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐  │
│  │STAGE│ │STAGE│ │STAGE│ │STAGE│ │STAGE│  │
│  │  1  │ │  2  │ │  3  │ │  4  │ │  5  │  │
│  │     │ │ ⭐⭐│ │ ⭐⭐⭐│ │ 🔒  │ │     │  │
│  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘  │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐  │
│  │STAGE│ │STAGE│ │STAGE│ │STAGE│ │STAGE│  │
│  │  6  │ │  7  │ │  8  │ │  9  │ │ 10  │  │
│  │     │ │     │ │ ⭐⭐ │ │ 🔒  │ │ 👹  │  │
│  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘  │
│                                             │
└─────────────────────────────────────────────┘
```

#### 월드 탭 (4개)

- **인간계** (🏯): 스테이지 1-10, 도깨비 주제
- **요괴계** (👹): 스테이지 11-20, 요괴 주제
- **용계** (🐉): 스테이지 21-30, 용의 영역
- **신계** (✨): 스테이지 31-40, 신 세계

##### 탭 디자인
- 비선택: 짙은 회색 (#2d2d2d)
- 선택: 진홍색 (#8B0000)
- 선택 상태: 금색 테두리 (2px)

#### 스테이지 버튼 (5열 그리드)

##### 표시 요소
- **STAGE 번호** (중앙): 흰색 텍스트, 크기 20
- **보스 마크** (👹): 보스 스테이지에만 표시
- **자물쇠 아이콘** (우상단, 빨강): 미해금 스테이지
- **별점** (하단, 노랑): 클리어 시 획득 별점 (⭐ × 1~3)
- **금색 테두리**: 클리어된 스테이지에만 표시

##### 버튼 배경색
- **일반 스테이지**: 어두운 회색 (#2d2d2d)
- **보스 스테이지**: 어두운 빨강 (#660000)

##### 잠금 해제 로직
```dart
isUnlocked = isStageClear(stageNumber) || stageNumber == 1;
```
- 첫 번째 스테이지는 항상 해금
- 이전 스테이지 클리어 후 다음 스테이지 해금

#### 사용자 상호작용
- 해금된 스테이지 클릭 → 해당 스테이지 시작
- 해금되지 않은 스테이지 → 클릭 불가

---

## ✅ 게임 중 HUD (InGameHUD)

### HUD 구성

```
┌──────────────────────────────────────────┐
│ STAGE 1    ⏱ 85.5 s    💰 1500          │
├──────────────────────────────────────────┤
│ 보유 아이템: 🔥 💣 ⚡ 🛡️                 │
└──────────────────────────────────────────┘
```

### 상단 정보 바

#### 좌측: 스테이지 정보
```
STAGE 1
```
- 폰트: 흰색, 굵음, 크기 16
- 레터 스페이싱: 1px
- 현재 플레이 중인 스테이지 번호 표시

#### 중앙: 남은 시간
```
⏱ 85.5 s
```
- 배경: 반투명 검정 (#000000 30%)
- 테두리: 회색 (기본) / 빨강 (경고 상태)
- **경고 조건**: 남은 시간 ≤ 30초
  - 배경: 빨강 (#FF6B6B 80%)
  - 텍스트: 굵음 처리
  - 테두리: 빨강 (2px)
- 소수점 1자리 표시

#### 우측: 현재 점수
```
💰 1500
```
- 폰트: 금색 (#FFD700), 굵음, 크기 16

### 아이템 표시 (선택적)

보유 아이템이 있을 경우에만 표시됩니다.

```
보유 아이템: 🔥 💣 ⚡ 🛡️
```

#### 아이템 아이콘
| 타입 | 아이콘 | 이름 |
|------|--------|------|
| fireUp | 🔥 | 범위 |
| bombUp | 💣 | 폭탄 |
| speedUp | ⚡ | 속도 |
| timeExtend | ⏳ | 시간 |
| shield | 🛡️ | 방패 |
| curse | 💀 | 저주 |

##### 아이콘 스타일
- 배경: 반투명 검정 (#000000 50%)
- 테두리: 회색
- 오른쪽 여백: 8px
- 호버 시: 아이템 이름 + 개수 표시

---

## 📊 UI 레이아웃 상세

### StageSelectionScreen 구조

```dart
Scaffold(
  appBar: AppBar(
    title: "스테이지 선택",
    backgroundColor: #8B0000,
  ),
  body: Column(
    children: [
      // 월드 탭 (높이 80)
      Container(
        height: 80,
        child: ListView(scrollDirection: Axis.horizontal),
      ),
      // 스테이지 그리드 (Expanded)
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1.0,
        ),
      ),
    ],
  ),
)
```

### InGameHUD 구조

```dart
Column(
  children: [
    // 상단 정보 바
    Container(
      padding: symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text('STAGE $number'),
          Text('⏱ $time s'),
          Text('💰 $score'),
        ],
      ),
    ),
    // 아이템 표시 (조건부)
    if (heldItems.isNotEmpty)
      Container(
        child: Row(items),
      ),
  ],
)
```

---

## 🔧 통합 방법

### 1. StageSelectionScreen 호출

```dart
// MainScreen 또는 GameScreen에서
final stage = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const StageSelectionScreen(),
  ),
);

if (stage != null) {
  // 선택된 스테이지로 게임 시작
  startGame(stage.stageNumber);
}
```

### 2. InGameHUD 표시 (BombermanGame)

```dart
class BombermanGame extends FlameGame {
  late BombermanGameScreen gameScreen;

  @override
  void onGameLifecycleEvent(GameLifecycleEvent event) {
    if (event == GameLifecycleEvent.attach) {
      // HUD 오버레이 추가
      add(HudComponent(
        stageNumber: currentStage,
        gameScreen: gameScreen,
      ));
    }
  }
}
```

### 3. SaveManager와 연동

```dart
// 스테이지 선택 전: 해금 상태 확인
bool isUnlocked = SaveManager().isStageClear(previousStage) || stageNumber == 1;

// 스테이지 클리어 후: 저장
await SaveManager().saveStageCleared(stageNumber);
await SaveManager().saveStageScore(stageNumber, finalScore);
await SaveManager().saveStageStar(stageNumber, starRating);
```

---

## 📈 사용자 흐름

### 게임 시작 → 스테이지 선택 → 게임 플레이

```
MainScreen
  ↓
StageSelectionScreen (월드 탭 + 스테이지 그리드)
  ↓ (스테이지 선택)
BombermanGame (게임 시작)
  ├─ InGameHUD (상단 정보 표시)
  ├─ GameBoard (게임 플레이)
  └─ 타이머 표시 및 경고
  ↓ (게임 종료)
ResultScreen (결과 화면)
  └─ SaveManager로 점수/별점 저장
  ↓
StageSelectionScreen (다음 스테이지 플레이 가능)
```

---

## 🎨 색상 팔레트

| 요소 | 색상 | HEX |
|------|------|-----|
| 배경 | 매우 어두운 회색 | #1a1a1a |
| 카드 배경 | 어두운 회색 | #2d2d2d |
| 보스 배경 | 어두운 빨강 | #660000 |
| 텍스트 (기본) | 흰색 | #FFFFFF |
| 텍스트 (강조) | 금색 | #FFD700 |
| AppBar | 진홍색 | #8B0000 |
| 경고 (시간) | 빨강 | #FF6B6B |
| 테두리 (선택) | 금색 | #FFD700 |

---

## ✅ 구현 체크리스트

- [x] StageSelectionScreen 생성
- [x] 4개 월드 탭 구현
- [x] 5열 스테이지 그리드
- [x] 스테이지 잠금/해금 상태 표시
- [x] 별점 표시
- [x] 보스 마크 표시
- [x] InGameHUD 생성
- [x] 상단 정보 바 (STAGE, 시간, 점수)
- [x] 30초 이하 경고 시스템
- [x] 아이템 표시
- [x] SaveManager 연동

---

## 📝 다음 단계

1. **HudComponent 구현**: Flame 게임에 직접 렌더링되는 HUD 컴포넌트
2. **ResultScreen**: 게임 클리어 후 점수 및 별점 표시
3. **GameScreen 수정**: StageSelectionScreen 통합
4. **오디오 통합**: 경고음 (30초 경고)

---

**구현 완료일**: 2026-03-29
**버전**: 1.0.0 (스테이지 진행 UI & 게임 HUD 완성)
