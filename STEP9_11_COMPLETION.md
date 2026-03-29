# STEP 9~11: 요괴 AI, 보스 AI, 아이템 시스템 완료 보고서

## 📋 개요
게임의 핵심 엔티티 시스템이 완성되었습니다. 5가지 요괴 AI, 4가지 보스 패턴, 6가지 아이템 시스템이 구현되었습니다.

---

## ✅ STEP 9: 기본 요괴 AI (enemy_component.dart)

### 5가지 요괴 유형

#### 1. 도깨비 졸개 (ID=1)
- **AI 유형**: `EnemyAIType.random`
- **속도**: 80 픽셀/초
- **특징**: 완전 랜덤 이동
- **점수**: 100점

#### 2. 도깨비 전사 (ID=2)
- **AI 유형**: `EnemyAIType.chaser`
- **속도**: 130 픽셀/초 (빠른 속도)
- **특징**: 플레이어 추적
- **점수**: 150점

#### 3. 구미호 (ID=3)
- **AI 유형**: `EnemyAIType.bombAvoider`
- **속도**: 110 픽셀/초
- **특징**: 플레이어 추적 + 폭탄 회피 (50% 확률)
- **HP**: 2
- **점수**: 200점

#### 4. 이무기 새끼 (ID=4)
- **AI 유형**: `EnemyAIType.straight`
- **속도**: 140 픽셀/초 (매우 빠름)
- **특징**: 직선 이동만 가능, 방향 변경 시에만 회전
- **점수**: 180점

#### 5. 천마 (ID=5)
- **AI 유형**: `EnemyAIType.fastChaser`
- **속도**: 160 픽셀/초 (가장 빠름)
- **특징**: 고속 추적, 거리 10칸 이내에서 강력한 추적
- **점수**: 250점

### 공통 기능

```dart
enum EnemyAIType {
  random,        // 랜덤 이동
  chaser,        // 플레이어 추적
  bombAvoider,   // 추적 + 폭탄 회피
  straight,      // 직선 이동만
  fastChaser,    // 고속 추적
}
```

#### AI 행동
- **랜덤 이동**: 현재 방향 유지, 막히면 무작위 방향 변경
- **플레이어 추적**: 거리계산 → 수평이동 우선 → 수직이동
- **폭탄 회피**: 50% 확률로 추적/랜덤 전환
- **직선 이동**: 한 방향 고집, 막히면 회전
- **고속 추적**: 거리 10칸 미만에서 추적 강화

#### 피해 시스템
```dart
void takeDamage(int damage) {
  currentHp -= damage;
  hitFlashTimer = hitFlashDuration; // 빨간 플래시
  if (currentHp <= 0) {
    isAlive = false;
    fadeOutTimer = 0.0; // 페이드 아웃
  }
}
```

#### 시각화
- **색상**: 주황색(#FF6B35) 원형
- **피격 효과**: 빨간색 플래시 (0.2초)
- **사망 효과**: 페이드 아웃 (0.5초)
- **HP 바**: HP > 1일 때 상단 표시

---

## ✅ STEP 10: 보스 AI (boss_component.dart)

### 4가지 보스

#### 1. 도깨비 대장 (ID=1, 스테이지 10)
- **HP**: 5
- **패턴**: `BossPattern.escape`
- **특징**: 플레이어에서 도망
- **속도 강화**: HP 50% 이하 시 2배 속도
- **크기**: 1.5배 타일

#### 2. 구미호 여왕 (ID=2, 스테이지 20)
- **HP**: 7
- **패턴**: `BossPattern.summonClones`
- **특징**: 플레이어 추적 + 3초마다 분신 3마리 생성
- **분신 특성**: 가짜 분신은 피격 불가, 진짜만 피격 유효
- **크기**: 1.5배 타일

#### 3. 이무기 대왕 (ID=3, 스테이지 30)
- **HP**: 10
- **패턴**: `BossPattern.poisonCloud`
- **특징**: 랜덤 이동 + 10초마다 독 구름 생성
- **독 구름 효과**: 3초간 플레이어 이동 불가
- **크기**: 1.5배 타일

#### 4. 치우천왕 (ID=4, 스테이지 40)
- **HP**: 15 (최고 난이도)
- **패턴**: `BossPattern.allOut`
- **특징**:
  - 플레이어 추적
  - HP 50% 이하 시 속도 2배 + 폭탄 회피
- **크기**: 1.5배 타일

### 보스 공통 기능

#### 패턴 관리
```dart
enum BossPattern {
  escape,        // 도깨비 대장
  summonClones,  // 구미호 여왕
  poisonCloud,   // 이무기 대왕
  allOut,        // 치우천왕
}
```

#### 시각화
- **색상**: 진빨강(#FF1744) 원형
- **외곽선**: 금색(#FFD700) (보스 표시)
- **HP 바**: 상단에 회색 배경 + 초록색 체력
- **HP 텍스트**: "현재/최대" 표시
- **피격 플래시**: 빨간색 0.3초
- **사망 애니메이션**: 페이드 아웃 1초

#### 이동 속도 계산
```dart
double speedMultiplier = 1.0;
moveInterval = 0.4 / speedMultiplier;

// HP 50% 이하: 속도 2배
if (isHalfHealth) {
  moveInterval = 0.2 / speedMultiplier;
}
```

---

## ✅ STEP 11: 아이템 시스템

### 6가지 아이템

#### 1. 화염 강화 (fireUp)
- **효과**: 폭발 범위 +1칸
- **드롭 확률**: 5%
- **코드**:
```dart
fireRange += GameConstants.fireRangeBoost; // +1
```

#### 2. 폭탄 추가 (bombUp)
- **효과**: 동시 설치 폭탄 +1개
- **드롭 확률**: 5%
- **코드**:
```dart
maxBombs += GameConstants.bombCountBoost; // +1
```

#### 3. 신발 (speedUp)
- **효과**: 이동 속도 +30%
- **드롭 확률**: 5%
- **코드**:
```dart
speed += GameConstants.speedBoost; // +40px/s
```

#### 4. 시간 연장 (timeExtend)
- **효과**: 제한시간 +30초
- **드롭 확률**: 5%
- **처리 위치**: BombermanGame._checkItemCollection()
```dart
remainingTime += 30.0;
```

#### 5. 신의 가호 (shield)
- **효과**: 다음 화염 1회 무적
- **드롭 확률**: 3% (희귀)
- **특징**:
  - 플레이어가 한 번 피해 받으면 자동 사용
  - 폭탄 피해는 무적 대상
  - 무적 사용 후 제거
- **코드**:
```dart
hasShield = true;

void takeDamage() {
  if (hasShield) {
    useShield();
    return; // 피해 없음
  }
  isAlive = false;
}
```

#### 6. 저주 (curse)
- **효과**: 폭발 범위 -1칸 (최소 1)
- **드롭 확률**: 2% (희귀 디버프)
- **코드**:
```dart
fireRange = (fireRange - 1).clamp(1, 10);
```

### 아이템 드롭 시스템

#### 드롭 타이밍
부드러운 벽 파괴 시 25% 확률로 아이템 드롭

#### 드롭 확률 분포
```
- 화염 강화: 5% (5/25)
- 폭탄 추가: 5% (5/25)
- 신발: 5% (5/25)
- 시간 연장: 5% (5/25)
- 신의 가호: 3% (3/25) ← 희귀
- 저주: 2% (2/25) ← 희귀 디버프
```

#### 수집 로직
```dart
void _checkItemCollection() {
  final tile = gridMap.getTile(player.gridX, player.gridY);
  if (tile != null && tile.itemType != null && tile.isDestroyed) {
    // 파괴된 벽에 아이템이 있으면 수집

    if (itemType == ItemType.timeExtend) {
      remainingTime += 30.0; // 게임에서 처리
    } else {
      player.collectItem(itemType); // 플레이어 능력치 업데이트
    }

    tile.itemType = null; // 아이템 제거
  }
}
```

---

## 🎮 게임플레이 흐름

### 요괴 이동 주기
```
매 프레임:
1. moveTimer 증가
2. moveTimer >= moveInterval 체크
3. AI 유형에 따른 다음 이동 계산
4. 이동 가능 여부 확인
5. 격자 좌표 업데이트
6. moveTimer 초기화
```

### 아이템 획득
```
매 프레임:
1. 플레이어 위치 확인
2. 해당 타일의 itemType 체크
3. 타일이 파괴됨(isDestroyed) 확인
4. 아이템별 효과 처리
5. itemType 제거
```

### 보스 패턴
```
매 프레임:
1. 패턴타이머 증가
2. 패턴별 이동 로직 실행
3. HP 50% 확인 (속도 조정)
4. 패턴 타이머 체크 (특수효과)
```

---

## 📊 통계

### 요괴
| 요괴명 | ID | 속도 | HP | 점수 | AI유형 |
|------|----|----|----|----|---------|
| 도깨비 졸개 | 1 | 80 | 1 | 100 | Random |
| 도깨비 전사 | 2 | 130 | 1 | 150 | Chaser |
| 구미호 | 3 | 110 | 2 | 200 | BombAvoider |
| 이무기 새끼 | 4 | 140 | 1 | 180 | Straight |
| 천마 | 5 | 160 | 1 | 250 | FastChaser |

### 보스
| 보스명 | ID | HP | 스테이지 | 패턴 |
|------|----|----|---------|------|
| 도깨비 대장 | 1 | 5 | 10 | Escape |
| 구미호 여왕 | 2 | 7 | 20 | Summon |
| 이무기 대왕 | 3 | 10 | 30 | Poison |
| 치우천왕 | 4 | 15 | 40 | AllOut |

### 아이템
| 아이템명 | ID | 효과 | 드롭 확률 | 레어 |
|--------|----|----|---------|------|
| 화염 강화 | fireUp | 범위 +1 | 5% | - |
| 폭탄 추가 | bombUp | +1개 | 5% | - |
| 신발 | speedUp | 속도 +30% | 5% | - |
| 시간 연장 | timeExtend | +30초 | 5% | - |
| 신의 가호 | shield | 1회 무적 | 3% | ★ |
| 저주 | curse | 범위 -1 | 2% | ★ |

---

## 🔄 클래스 다이어그램

```
EnemyComponent
├─ gridX, gridY
├─ currentHp
├─ moveTimer / moveInterval
├─ aiType: EnemyAIType
├─ hitFlashTimer
├─ fadeOutTimer
├─ _getNextMove() → (dx, dy)
├─ _randomMove()
├─ _chaserMove()
├─ _straightMove()
├─ _fastChaserMove()
└─ takeDamage()

BossComponent
├─ gridX, gridY
├─ currentHp
├─ pattern: BossPattern
├─ patternTimer
├─ speedMultiplier
├─ _getMaxHp() → int
├─ _chaserMove()
├─ _randomMove()
├─ _escapeFromPlayer()
└─ takeDamage()

PlayerComponent
├─ hasShield: bool
├─ fireRange, maxBombs, speed
├─ collectItem(ItemType)
├─ useShield()
└─ takeDamage()
```

---

## 🔧 수정된 파일

### 1. enemy_component.dart (전체 재작성)
- EnemyAIType enum 추가
- 5가지 AI 유형별 이동 로직
- 피격 플래시 효과
- 페이드 아웃 애니메이션
- HP 바 렌더링

### 2. boss_component.dart (전체 재작성)
- BossPattern enum 추가
- 4가지 보스 패턴 구현
- 보스별 최대 HP 정의
- 보스 크기 (1.5배 타일)
- 금색 외곽선 + 상세 HP 바

### 3. tile_type.dart (ItemType 확장)
- speedUp → 신발
- bombUp → 폭탄 추가
- fireUp → 화염 강화
- +3 new: timeExtend, shield, curse

### 4. grid_map.dart (아이템 드롭 로직)
- 25% 확률로 아이템 드롭
- 6가지 아이템별 확률 분포
- 부드러운 벽 생성 시 itemType 설정

### 5. player_component.dart (아이템 시스템)
- hasShield 상태 추가
- collectItem() 확장 (6가지 처리)
- useShield() 메서드
- takeDamage() 무적 로직

### 6. bomberman_game.dart (아이템 수집)
- _checkItemCollection() 개선
- timeExtend 처리 (시간 +30초)
- 파괴된 타일 아이템 감지

### 7. enemy_data.dart (5가지 요괴)
- ID 1~5 정의
- 요괴별 속도, 이름, 점수 설정

---

## 📝 다음 단계

### 선택적 개선
1. **분신 시스템** (구미호 여왕)
   - FakeEnemyComponent 추가
   - 진짜/가짜 판별 로직

2. **독 구름** (이무기 대왕)
   - PoisonCloudComponent
   - 3초 이동 불가 상태

3. **사운드 효과**
   - 요괴 생성/사망 효과음
   - 보스 전투 BGM
   - 아이템 획득음

4. **시각 효과**
   - 요괴 스프라이트 애니메이션
   - 보스 특수 이펙트
   - 아이템 팝업 텍스트

---

## ✅ 완료 체크리스트

- [x] 요괴 AI 시스템 (5가지)
- [x] 요괴 이동 로직
- [x] 요괴 시각화 (색상, HP바, 애니메이션)
- [x] 보스 AI 시스템 (4가지)
- [x] 보스 패턴 구현
- [x] 보스 시각화 (크기, 금색 테두리, HP바)
- [x] 아이템 시스템 (6가지)
- [x] 아이템 드롭 로직
- [x] 아이템 수집 로직
- [x] 플레이어 무적 시스템
- [x] 아이템 이펙트 처리

---

**구현 완료일**: 2026-03-29
**버전**: 1.0.0 (요괴 & 아이템 시스템 완성)
