# STEP 31: 게임 밸런스 조정 완료 보고서

## 📋 밸런스 조정 목표

**목표**: 스테이지별 난이도 곡선을 부드럽게 구성하여 게임 진행성 향상

**기준**:
- 초반(1-5): 튜토리얼 느낌의 쉬운 난이도
- 중반(6-30): 점진적 난이도 상승
- 후반(31-39): 높은 난이도 유지
- 최종(40): 최고 난이도 (최종 보스)

---

## ✅ 수행된 밸런스 조정

### 1️⃣ 스테이지 데이터 확장

**파일**: `lib/game/data/stage_data.dart`

#### 추가된 필드

```dart
class StageData {
  /// 요괴 이동 속도 배수 (기본값 1.0)
  final double enemySpeed;

  /// 부드러운 벽 밀도 (0.0~1.0, 높을수록 어려움)
  final double softWallDensity;

  /// 아이템 등장 확률 (0.0~1.0, 높을수록 많음)
  final double itemDropRate;
}
```

---

### 2️⃣ 스테이지별 밸런스 설정

#### 📊 스테이지 난이도 테이블

| 구간 | 스테이지 | 요괴속도 | 벽밀도 | 아이템% | 설명 |
|------|---------|---------|--------|--------|------|
| **쉬움** | 1-5 | 0.8~0.9 | 0.2 | 70-80% | 튜토리얼 |
| **보통** | 6-9 | 1.0~1.1 | 0.3 | 40-50% | 입문 |
| **보통~중간** | 10 (보스) | 1.2 | 0.3 | 30% | 첫 보스 |
| **보통** | 11-15 | 1.1~1.2 | 0.35 | 40% | 요괴계 진입 |
| **중간** | 16-19 | 1.2~1.3 | 0.4 | 30% | 난이도 상승 |
| **중간** | 20 (보스) | 1.4 | 0.4 | 25% | 2번째 보스 |
| **중간** | 21-25 | 1.3~1.4 | 0.45 | 30% | 용계 진입 |
| **어려움** | 26-29 | 1.4~1.5 | 0.5 | 20% | 난이도 급상승 |
| **어려움** | 30 (보스) | 1.5 | 0.5 | 15% | 3번째 보스 |
| **어려움** | 31-35 | 1.4~1.5 | 0.5 | 20% | 신계 진입 |
| **매우어려움** | 36-39 | 1.5~1.6 | 0.55~0.6 | 15% | 최고 난이도 |
| **최종보스** | 40 | 1.6 | 0.6 | 10% | 최종 보스 |

---

### 3️⃣ 밸런스 파라미터 설명

#### 🎯 요괴 이동 속도 (enemySpeed)

**적용 방식**: EnemyComponent와 BossComponent의 moveInterval에 곱하기 적용

```dart
// EnemyComponent에서
moveInterval = GridMap.tileSize / (enemyData.speed * speedMultiplier);
```

**효과**:
- 0.8: 기본 속도의 80% (느림)
- 1.0: 기본 속도 (보통)
- 1.2: 기본 속도의 120% (빠름)
- 1.6: 기본 속도의 160% (매우 빠름)

#### 🧱 부드러운 벽 밀도 (softWallDensity)

**적용 방식**: GridMap의 타일 생성 시 확률로 적용

```dart
// GridMap의 _createTile()에서
if (_random.nextDouble() < softWallDensity) {
  // 부드러운 벽 생성
}
```

**효과**:
- 0.2: 20% 확률 (열려있음, 쉬움)
- 0.3: 30% 확률 (보통)
- 0.5: 50% 확률 (복잡함, 어려움)
- 0.6: 60% 확률 (매우 복잡함)

#### 🎁 아이템 드롭 확률 (itemDropRate)

**적용 방식**: 부드러운 벽에 아이템 포함 여부 결정

```dart
// GridMap의 _createTile()에서
if (_random.nextDouble() < itemDropRate) {
  // 아이템 종류 결정
}
```

**효과**:
- 0.1: 10% 확률 (거의 없음)
- 0.3: 30% 확률 (적음)
- 0.5: 50% 확률 (보통)
- 0.8: 80% 확률 (많음)

---

### 4️⃣ 코드 구현 변경사항

#### 📁 수정된 파일

**1. lib/game/data/stage_data.dart**
- StageData 클래스에 3개 필드 추가
- 40개 스테이지 모두 밸런스 값 할당

**2. lib/game/components/enemy_component.dart**
- 생성자에 `speedMultiplier` 파라미터 추가
- moveInterval 계산에 speedMultiplier 적용

```dart
EnemyComponent({
  ...
  double speedMultiplier = 1.0,
}) {
  moveInterval = GridMap.tileSize / (enemyData.speed * speedMultiplier);
}
```

**3. lib/game/components/boss_component.dart**
- 생성자에 `bosSpeedMultiplier` 파라미터 추가
- 속도 조정 메커니즘 구현

```dart
BossComponent({
  ...
  double bosSpeedMultiplier = 1.0,
}) {
  speedMultiplier = bosSpeedMultiplier;
  moveInterval = 0.4 / speedMultiplier;
}
```

**4. lib/game/map/grid_map.dart**
- 생성자에 `softWallDensity`, `itemDropRate` 파라미터 추가
- 타일 생성 로직 수정

```dart
GridMap({
  this.softWallDensity = 0.3,
  this.itemDropRate = 0.5,
})

void _createTile(int x, int y) {
  if (_random.nextDouble() < softWallDensity) {
    if (_random.nextDouble() < itemDropRate) {
      // 아이템 생성
    }
  }
}
```

**5. lib/game/bomberman_game.dart**
- 모든 밸런스 파라미터 적용

```dart
// 게임 시간
remainingTime = currentStage.timeLimit.toDouble();

// 맵 생성
gridMap = GridMap(
  softWallDensity: currentStage.softWallDensity,
  itemDropRate: currentStage.itemDropRate,
);

// 요괴 생성
final enemy = EnemyComponent(
  ...
  speedMultiplier: currentStage.enemySpeed,
);

// 보스 생성
final boss = BossComponent(
  ...
  bosSpeedMultiplier: currentStage.enemySpeed,
);
```

---

## 🎮 밸런스 설계 철학

### 초반 (1-5): 학습 곡선
```
목표: 플레이어가 게임 메커니즘 이해
- 느린 요괴 (0.8~0.9 배속)
- 열린 맵 (20% 벽 밀도)
- 풍부한 아이템 (70-80% 드롭)
```

### 중반 (6-25): 점진적 상승
```
목표: 난이도를 서서히 올리며 도전감 제공
- 점진적 속도 증가 (1.0 → 1.3 배속)
- 적당한 벽 (30-40% 밀도)
- 감소하는 아이템 (50% → 30%)
```

### 후반 (26-39): 고난이도
```
목표: 플레이어의 숙련도 시험
- 빠른 요괴 (1.4~1.6 배속)
- 복잡한 맵 (50-60% 벽 밀도)
- 아이템 부족 (15-20% 드롭)
```

### 최종 (40): 극한 도전
```
목표: 최고 수준의 도전과제
- 최고 속도 (1.6 배속, 보스 패턴)
- 최대 벽 밀도 (60%)
- 최소 아이템 (10%)
```

---

## 📊 진행도 곡선 (권장)

```
난이도
  5 |                              ███████
  4 |                    ██████ ██ ███████
  3 |            ██████████  ██  ███
  2 |        ██████     ██  ██████
  1 |    ██████   ██  ██
  0 |__███_____██__██__________
     0  10  20  30  40 (스테이지)
```

**특징**:
- 완만한 초반 (0-5)
- 중반 급상승 (10-20)
- 후반 안정화 (25-39)
- 최종 피크 (40)

---

## 🔧 배포 시 조정 가능 항목

### 튜닝 포인트

**쉽게 변경 가능한 파라미터** (게임 재시작 필요):

```dart
// 1. 전체 난이도 스케일 조정
final difficultyScale = 1.0; // 0.8(쉬움), 1.0(정상), 1.2(어려움)

// 2. 속도 조정
enemySpeed *= difficultyScale;

// 3. 아이템 확률 조정
itemDropRate *= difficultyScale;

// 4. 벽 밀도 조정
softWallDensity *= difficultyScale;
```

### 피드백 기반 조정 사항

유저 데이터 기반 조정 예시:
- "Stage 15 클리어율 15% 이하" → softWallDensity 0.35 → 0.30으로 감소
- "Stage 30 평균 클리어 시간 300초 이상" → timeLimit 90 → 120으로 증가
- "Stage 35+ 아이템 부족" → itemDropRate 0.2 → 0.25로 증가

---

## ✅ 최종 검증 체크리스트

- [x] StageData 필드 추가 완료
- [x] 40개 스테이지 밸런스 값 할당
- [x] EnemyComponent speedMultiplier 적용
- [x] BossComponent bosSpeedMultiplier 적용
- [x] GridMap softWallDensity 적용
- [x] GridMap itemDropRate 적용
- [x] BombermanGame 통합 완료
- [x] timeLimit 동적 적용

---

## 🚀 다음 단계

### 즉시 작업 가능
1. **테스트 플레이** - 각 스테이지 밸런스 검증
2. **클리어율 모니터링** - 각 스테이지별 클리어 시간 측정
3. **사용자 피드백** - 난이도 체감 조사

### 향후 개선
1. **동적 난이도 조정** - 플레이 데이터 기반 자동 조정
2. **아이템 패턴 분석** - 드롭 확률 미세 조정
3. **보스별 밸런스** - 보스 타입별 개별 파라미터

---

**조정 완료일**: 2026-03-29
**버전**: 1.2.1 (밸런스 조정)
**테스트 필요**: 모든 스테이지 (1-40)
