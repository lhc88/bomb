# 게임 맵 시스템 가이드

## 📋 맵 구성

### GridMap (15 x 13)
```
폭: 15 타일 × 40px = 600px
높이: 13 타일 × 40px = 520px
```

## 🗺️ TileType (5가지)

### 1. EMPTY (빈 공간)
- **이동**: ✅ 가능
- **파괴**: ❌ 불가능
- **아이템**: ❌ 없음
- **색상**: #2C1810 (진갈색 - 배경색)

### 2. HARD_WALL (단단한 벽)
- **이동**: ❌ 불가능
- **파괴**: ❌ 불가능
- **아이템**: ❌ 없음
- **색상**: #4A4A4A (회색)
- **배치**: 짝수 행/열 교차점 (자동)

### 3. SOFT_WALL (부드러운 벽)
- **이동**: ❌ 불가능 (파괴 전)
- **파괴**: ✅ 가능
- **아이템**: ✅ 30% 확률
- **색상**: #8B6F47 (갈색)
- **배치**: 빈 공간의 60% 확률

### 4. EXIT (출구)
- **이동**: ✅ 가능 (활성화 후)
- **파괴**: ❌ 불가능
- **아이템**: ❌ 없음
- **색상**: #FFD700 (활성) / #B8860B (비활성)
- **활성화**: 모든 요괴 처치 후

### 5. ITEM (아이템)
- **이동**: ✅ 가능
- **파괴**: ✅ 가능 (부드러운 벽 파괴 시)
- **아이템 타입**:
  - **SpeedUp**: 속도 증가
  - **BombUp**: 폭탄 증가
  - **FireUp**: 범위 증가
- **색상**: #FF6B35 (주황색)

## 📊 맵 배치 규칙

### 1단계: 경계 생성
- 가장자리(0행, 마지막행, 0열, 마지막열) → **HARD_WALL**

### 2단계: 격자 패턴 벽
- x % 2 == 0 && y % 2 == 0 → **HARD_WALL**
```
X . X . X . X . X .
. . . . . . . . . .
X . X . X . X . X .
. . . . . . . . . .
...
```

### 3단계: 플레이어 시작 지점 보호
- (1,1) 주변 3칸: (0~2, 0~2) → **EMPTY**
- (13,1) 주변 3칸: (12~14, 0~2) → **EMPTY**
- (1,11) 주변 3칸: (0~2, 10~12) → **EMPTY**
- (13,11) 주변 3칸: (12~14, 10~12) → **EMPTY**

### 4단계: 부드러운 벽 랜덤 배치
- 나머지 공간의 60% → **SOFT_WALL** (30% 확률로 아이템 포함)
- 나머지 40% → **EMPTY**

## 🎮 ItemType (3가지)

### SpeedUp
```
아이템 타입: ItemType.speedUp
효과: 플레이어 속도 40px/초 증가
```

### BombUp
```
아이템 타입: ItemType.bombUp
효과: 배치 가능한 폭탄 개수 +1
```

### FireUp
```
아이템 타입: ItemType.fireUp
효과: 폭발 범위 +1 타일
```

## 🔧 GridMap 주요 메서드

### 초기화 및 조회
```dart
// 맵 생성 및 초기화
final map = GridMap();

// 타일 조회
Tile? tile = map.getTile(5, 6);

// 격자 좌표 유효성 확인
bool valid = map.isValidGridPosition(5, 6);

// 이동 가능 여부
bool walkable = map.isWalkable(5, 6);
```

### 좌표 변환
```dart
// 월드 좌표 → 격자 좌표
final (gridX, gridY) = map.worldToGrid(200.0, 240.0);

// 격자 좌표 → 월드 좌표
final (worldX, worldY) = map.gridToWorld(5, 6);
```

### 폭발 처리
```dart
// 폭발 범위 내 타일 파괴
List<(int, int)> destroyed = map.destroyTilesInExplosion(
  centerGridX: 7,
  centerGridY: 6,
  fireRange: 2,
);

// 폭발 영향 범위 조회 (파괴하지 않음)
List<(int, int)> affected = map.getTilesInExplosion(
  centerGridX: 7,
  centerGridY: 6,
  fireRange: 2,
);
```

### 출구 제어
```dart
// 모든 요괴 처치 후 출구 활성화
map.activateExit();

// 출구 비활성화
map.deactivateExit();

// 맵 리셋
map.reset();
```

## 📐 폭발 범위 계산

### 중심 타일에서 4방향으로 확산
```
        [범위 2]
           ↑
        [ ■ ]
        [ ■ ]
← [ ■ ][ P ][ ■ ] →
        [ ■ ]
        [ ■ ]
           ↓
        [범위 2]
```

### 차단 규칙
1. **HARD_WALL** → 즉시 차단
2. **SOFT_WALL** → 파괴 후 차단
3. **EMPTY/EXIT/ITEM** → 통과

## 🎨 타일 색상 렌더링

```dart
// 각 타일은 색상 사각형으로 렌더링됨
// 40px × 40px 크기

EMPTY:      #2C1810 (진갈색)
HARD_WALL:  #4A4A4A (회색)
SOFT_WALL:  #8B6F47 (갈색)
SOFT_WALL (파괴됨): #3D2817 (진갈색)
EXIT (비활성): #B8860B (어두운 금색)
EXIT (활성): #FFD700 (밝은 금색)
ITEM: #FF6B35 (주황색)
```

## 💡 사용 예제

### 기본 사용
```dart
// 맵 생성
final map = GridMap();

// 플레이어가 (5, 6) 위치로 이동 가능한지 확인
if (map.isWalkable(5, 6)) {
  // 이동 처리
}

// 폭탄 폭발
final affectedTiles = map.destroyTilesInExplosion(5, 6, fireRange: 2);
for (final (x, y) in affectedTiles) {
  // 폭발 처리
}

// 아이템 획득
final tile = map.getTile(5, 6);
if (tile?.type == TileType.item && tile?.itemType == ItemType.speedUp) {
  // 속도 증가 적용
}
```

### 게임 로직
```dart
// 모든 요괴 처치 후
map.activateExit();

// 플레이어가 출구에 접근
if (map.isWalkable(exitX, exitY)) {
  // 다음 스테이지로
}
```

## 📊 맵 통계

```
총 타일 수: 15 × 13 = 195
HARD_WALL: ~52개 (26%)
SOFT_WALL: ~60개 (31%)
EMPTY: ~80개 (41%)
ITEM: ~18개 (9%) - SOFT_WALL 중 30%

맵 크기: 600px × 520px
타일 크기: 40px × 40px
```

## 🔍 디버그

```dart
// 맵 상태 출력
map.printMapDebug();

// 출력 예:
// === GridMap Debug Info ===
// Size: 15 x 13
// Tile Size: 40.0 px
// Total Tiles: 195
// Hard Walls: 52
// Soft Walls: 60
// Empty: 80
// Items: 18
// Exits: 1
```

---

**파일 위치**: `lib/game/map/`  
- `tile_type.dart` (102줄)
- `grid_map.dart` (333줄)

**생성일**: 2026-03-29  
**상태**: ✅ 완성
