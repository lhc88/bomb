# STEP 12~14: 캐릭터 시스템 & 저장 시스템 완료 보고서

## 📋 개요

게임의 캐릭터 선택 시스템과 데이터 저장 시스템이 완성되었습니다.

---

## ✅ STEP 12: 캐릭터 데이터 클래스

### CharacterData 클래스 구조

```dart
class CharacterData {
  final int id;                    // 캐릭터 고유 ID (1~10)
  final String koreanName;         // 한국어 이름
  final String nameEn;             // 영문 이름
  final int bombRange;             // 폭발 범위 (2~6)
  final int bombCount;             // 동시 설치 폭탄 (1~5)
  final double speed;              // 이동 속도 (80~160 px/s)
  final double fuseTime;           // 폭탄 지연 (1.0~3.0초)
  final String passiveSkill;       // 패시브 스킬 설명
  final String unlockCondition;    // 해금 조건
  final String unlockType;         // 해금 타입 (none, watchAd, purchase, stageClear)
  final dynamic unlockValue;       // 해금 값 (가격, 스테이지 등)
  final String imageAsset;         // 이미지 에셋
  bool isUnlocked;                 // 해금 여부 (mutable)
}
```

### 10가지 캐릭터 데이터

| ID | 이름 | 범위 | 폭탄 | 속도 | 지연 | 패시브 | 해금 조건 |
|----|-----|------|------|------|------|-------|---------|
| 1 | 웅녀의 전사 | 2 | 1 | 120 | 3.0s | 기본 | 처음부터 |
| 2 | 바리데기 | 2 | 2 | 140 | 3.0s | 부활 | 광고 |
| 3 | 주몽 | 4 | 1 | 140 | 3.0s | 신궁 | 광고 |
| 4 | 선덕여왕 | 3 | 3 | 120 | 2.5s | 통찰 | 광고 |
| 5 | 을지문덕 | 3 | 2 | 120 | 1.5s | 속전속결 | 광고 |
| 6 | 연오랑 | 3 | 2 | 160 | 3.0s | 광속 | ₩1,200 |
| 7 | 온달 장군 | 5 | 1 | 80 | 3.0s | 대지강타 | ₩1,200 |
| 8 | 광개토대왕 | 4 | 4 | 140 | 2.0s | 정복 | ₩1,200 |
| 9 | 환웅 | 6 | 3 | 140 | 2.0s | 뇌신 | ₩1,200 |
| 10 | 단군왕검 | 6 | 5 | 160 | 1.0s | 홍익인간 | 40스테이지 |

### Characters 클래스 기능

```dart
class Characters {
  static CharacterData? getCharacter(int id)                    // ID로 캐릭터 조회
  static CharacterData defaultCharacter()                       // 기본 캐릭터 반환
  static List<CharacterData> getUnlockedCharacters()            // 해금된 캐릭터
  static List<CharacterData> getLockedCharacters()              // 잠긴 캐릭터
  static List<CharacterData> getAdUnlockableCharacters()        // 광고 해금 가능
  static List<CharacterData> getPurchaseUnlockableCharacters()  // 구매 해금 가능
  static List<CharacterData> getStageUnlockableCharacters()     // 스테이지 해금 가능
  static void unlockCharacter(int id)                           // 캐릭터 해금
  static void printCharacterInfo(int id)                        // 디버그 출력
}
```

---

## ✅ STEP 13: 캐릭터 선택 화면

### 화면 구성

#### 1. AppBar
- 제목: "캐릭터 선택"
- 진홍색(#8B0000) 배경

#### 2. 캐릭터 그리드 (2열)
- **해금된 캐릭터**:
  - 이름 표시
  - 첫 글자 아이콘 (70x70px)
  - 능력치 바 4개 (범위, 폭탄, 속도, 지연)
  - 선택 시 금색 테두리 + 그림자

- **잠긴 캐릭터**:
  - 자물쇠 아이콘 (우상단)
  - 해금 조건 텍스트
  - 50% 투명도
  - 구매: 파란색 태그 (₩1,200)
  - 광고: 주황색 태그 (광고 해금)

#### 3. 선택 버튼
- 크기: 전체 너비
- 색상: 초록색(#4CAF50)
- 선택된 캐릭터가 해금되어야만 활성화

### 능력치 표시

```
범위 ▓▓▓▓░░ 4    (최대 6)
폭탄 ▓▓▓░░░ 3    (최대 5)
속도 ▓▓▓▓░░ 4    (최대 4 레벨)
지연 ▓▓▓▓░░ 4    (역순: 1초=4, 3초=1)
```

### UI 레이아웃

```
[AppBar: 캐릭터 선택]

[그리드 영역 (2열)]
┌─────────────────────────────┐
│  ┌─────┐    ┌─────┐         │
│  │  웅  │    │  바 │ 🔒      │
│  │  녀  │    │  리 │ ₩1,200  │
│  └─────┘    └─────┘         │
│  범위 ▓▓░░  범위 ▓░░░        │
│  폭탄 ▓░░░  폭탄 ▓▓░░        │
│  속도 ▓▓░░  속도 ▓▓▓░        │
│  지연 ▓▓▓░  지연 ▓▓▓░        │
│  [선택됨]   [광고해금]       │
│ ... (더 많은 캐릭터)          │
└─────────────────────────────┘

[선택 버튼]
```

### 초기화 로직

```dart
@override
void initState() {
  // 저장된 선택 캐릭터 로드
  selectedCharacterId = SaveManager().loadSelectedCharacter();
}
```

---

## ✅ STEP 14: 저장 시스템 (SaveManager)

### 저장 항목

#### 1. 캐릭터 관리
```dart
saveSelectedCharacter(int characterId)        // 선택한 캐릭터 저장
loadSelectedCharacter() → int                 // 선택 캐릭터 로드 (기본값: 1)

saveUnlockedCharacters(List<int> ids)        // 해금 캐릭터 저장
loadUnlockedCharacters() → List<int>         // 해금 캐릭터 로드

unlockCharacter(int characterId)              // 특정 캐릭터 해금
```

#### 2. 스테이지 진행
```dart
saveStageCleared(int stageNumber)            // 스테이지 클리어 저장
loadStageClear() → Map<int, bool>            // 클리어 여부 맵
isStageClear(int stageNumber) → bool         // 특정 스테이지 확인
```

#### 3. 스테이지 점수
```dart
saveStageScore(int stage, int score)         // 최고 점수만 저장
loadStageScores() → Map<int, int>            // 모든 점수 로드
getStageScore(int stage) → int               // 특정 점수 조회
```

#### 4. 스테이지 별점
```dart
saveStageStar(int stage, int stars)          // 별점 저장 (1~3)
loadStageStars() → Map<int, int>             // 모든 별점 로드
getStageStar(int stage) → int                // 특정 별점 조회
```

#### 5. 전체 점수
```dart
saveTotalScore(int score)                    // 전체 최고 점수
loadTotalScore() → int                       // 최고 점수 조회 (기본값: 0)
```

#### 6. 게임 설정
```dart
saveGameSettings({
  required bool soundEnabled,                // 효과음 on/off
  required bool musicEnabled,                // BGM on/off
  required bool vibrationEnabled,            // 진동 on/off
})

loadGameSettings() → Map<String, bool>       // 설정 로드
```

#### 7. 광고 제거
```dart
saveAdsFree(bool isFree)                     // 광고 제거 구매 저장
loadAdsFree() → bool                         // 광고 제거 여부 (기본값: false)
```

### 데이터 구조

```
SharedPreferences 저장소:
{
  'bomberman_selected_char': 1,                    // int
  'bomberman_unlocked_chars': '[1,2,3]',          // JSON List<int>
  'bomberman_stage_clear': '{"1":true,"2":true}', // JSON Map<String, bool>
  'bomberman_stage_scores': '{"1":1000,"2":950}', // JSON Map<String, int>
  'bomberman_stage_stars': '{"1":3,"2":2}',       // JSON Map<String, int>
  'bomberman_settings': '{"sound":true,...}',     // JSON Map<String, bool>
  'bomberman_ads_free': false,                    // bool
  'bomberman_total_score': 50000,                 // int
}
```

### 싱글톤 패턴

```dart
static final SaveManager _instance = SaveManager._internal();

factory SaveManager() {
  return _instance;  // 항상 같은 인스턴스 반환
}
```

### 앱 시작 시 초기화

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SaveManager 초기화 (SharedPreferences 로드)
  await SaveManager().initialize();

  runApp(const MyApp());
}
```

### 데이터 저장 정책

- **자동 저장**: 변경 즉시 저장 (await 사용)
- **최고 점수**: 현재 점수가 더 높을 때만 업데이트
- **더 높은 별점**: 기존 별점보다 높을 때만 업데이트
- **스테이지 클리어**: 한 번 클리어되면 변경 불가

---

## 📊 저장 데이터 예시

### 신규 사용자
```
선택 캐릭터: 1 (웅녀의 전사)
해금 캐릭터: [1]
클리어: {}
점수: {}
별점: {}
설정: {sound: true, music: true, vibration: true}
광고제거: false
```

### 게임 진행 중
```
선택 캐릭터: 3 (주몽)
해금 캐릭터: [1, 2, 3, 4]
클리어: {1: true, 2: true, 3: false}
점수: {1: 1500, 2: 1200}
별점: {1: 3, 2: 2}
설정: {sound: true, music: false, vibration: true}
광고제거: false
총점수: 5000
```

### 광고 해금 후
```
해금 캐릭터: [1, 2, 3, 4, 5]  // 광고 캐릭터 추가
```

### 구매 후
```
해금 캐릭터: [1, 2, 3, 4, 5, 6, 7, 8, 9]  // 구매 캐릭터 추가
```

### 스테이지 40 클리어
```
해금 캐릭터: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  // 최종 보스 캐릭터 해금
클리어: {1~40: true}
```

---

## 🔧 디버그 기능

### 디버그 정보 출력

```dart
SaveManager().printDebugInfo();

// 출력:
// === SaveManager Debug Info ===
// Selected Character: 3
// Unlocked Characters: [1, 2, 3, 4, 5]
// Cleared Stages: {1: true, 2: true, ...}
// Stage Scores: {1: 1500, 2: 1200, ...}
// Stage Stars: {1: 3, 2: 2, ...}
// Total Score: 5000
// Ads Free: false
// Settings: {sound: true, music: true, vibration: true}
```

### 데이터 초기화

```dart
// 모든 데이터 삭제
await SaveManager().clearAllData();

// 게임 진행만 리셋 (캐릭터, 설정 유지)
await SaveManager().resetGameProgress();
```

---

## 🎮 통합 플로우

### 앱 시작 → 캐릭터 선택 → 게임 시작

```
main.dart
  ↓
SaveManager.initialize()  // SharedPreferences 로드
  ↓
MainScreen  // 메인 화면
  ↓
CharacterScreen  // 캐릭터 선택
  (loadSelectedCharacter() → UI 표시)
  (loadUnlockedCharacters() → 해금 표시)
  ↓
GameScreen  // 게임 시작
  (GameConstants의 defaultBombCount 등 사용)
  ↓
게임 종료 후
  saveStageCleared()
  saveStageScore()
  saveStageStar()
  saveTotalScore()
```

---

## 📈 사용자 진행 경로

### 1단계: 초기 플레이
- 웅녀의 전사만 해금
- 스테이지 1~9 진행

### 2단계: 광고 해금
- 바리데기, 주몽, 선덕여왕, 을지문덕 광고로 해금
- 능력치 다양화

### 3단계: 인앱 구매
- 연오랑, 온달 장군, 광개토대왕, 환웅 구매 ($1.20 × 4 = $4.80)
- 모든 일반 캐릭터 해금

### 4단계: 최종 도전
- 스테이지 40 클리어 → 단군왕검 해금
- 최고 난이도 캐릭터로 플레이

---

## 📝 파일 수정 사항

### 1. character_data.dart (완전 재작성)
- CharacterData 클래스 확장
- 10가지 캐릭터 데이터 정의
- 해금 조건 시스템 추가
- 유틸리티 메서드 추가

### 2. character_screen.dart (완전 재작성)
- 그리드 기반 UI (2열)
- 능력치 바 표시
- 해금 상태 시각화
- 광고/구매 태그 표시
- 선택 버튼 통합

### 3. save_manager.dart (확장)
- 캐릭터 해금 시스템
- 스테이지 진행 저장
- 점수 및 별점 시스템
- 게임 설정 저장
- 광고 제거 구매 여부

---

## ✅ 완료 체크리스트

- [x] CharacterData 클래스 정의
- [x] 10가지 캐릭터 데이터 입력
- [x] 해금 조건 시스템
- [x] Characters 유틸리티 클래스
- [x] 캐릭터 선택 화면 UI
- [x] 능력치 바 렌더링
- [x] 해금 상태 표시
- [x] 구매/광고 태그
- [x] SaveManager 확장
- [x] 캐릭터 해금 저장
- [x] 스테이지 진행 저장
- [x] 점수 시스템 저장
- [x] 별점 시스템 저장
- [x] 게임 설정 저장
- [x] 광고 제거 구매 여부 저장

---

**구현 완료일**: 2026-03-29
**버전**: 1.0.0 (캐릭터 & 저장 시스템 완성)
