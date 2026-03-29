import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/character_data.dart';
import '../map/grid_map.dart';
import '../map/tile_type.dart';
import '../../utils/constants.dart';

/// 플레이어 컴포넌트 - 그리드 기반 이동 시스템
class PlayerComponent extends PositionComponent {
  /// 캐릭터 데이터
  final CharacterData character;

  /// 격자 맵 참조
  final GridMap map;

  /// 격자 좌표
  late int gridX;
  late int gridY;

  /// 플레이어 능력치
  late double speed;
  late int maxBombs;
  late int fireRange;
  late int bombCount;

  /// 특수 아이템 상태
  bool hasShield = false; // 신의 가호 (1회 무적)

  /// 이동 상태
  bool isMoving = false;
  int? targetGridX;
  int? targetGridY;
  double movementProgress = 0.0;

  /// 입력 큐 (이동 중 다음 입력 저장)
  int? pendingDirectionX;
  int? pendingDirectionY;

  /// 생존 상태
  bool isAlive = true;

  /// 플레이어 색상 (파란색)
  static const Color playerColor = Color(0xFF2196F3);
  static const Color playerBorderColor = Colors.white;

  PlayerComponent({
    required this.character,
    required this.map,
    required int startGridX,
    required int startGridY,
  }) : super(
    size: Vector2(GridMap.tileSize, GridMap.tileSize),
  ) {
    gridX = startGridX;
    gridY = startGridY;
    speed = character.speed;
    maxBombs = character.maxBombs;
    fireRange = character.fireRange;
    bombCount = 0;
    _updatePosition();
  }

  /// 월드 좌표 업데이트
  void _updatePosition() {
    final (worldX, worldY) = map.gridToWorld(gridX, gridY);
    position = Vector2(worldX, worldY);
  }

  /// 이동 시도
  void tryMove(int directionX, int directionY) {
    if (!isAlive) return;

    // 이미 이동 중이면 다음 방향을 큐에 저장
    if (isMoving) {
      pendingDirectionX = directionX;
      pendingDirectionY = directionY;
      return;
    }

    final nextGridX = gridX + directionX;
    final nextGridY = gridY + directionY;

    // 격자 범위 확인
    if (!map.isValidGridPosition(nextGridX, nextGridY)) {
      return;
    }

    // 이동 가능 여부 확인
    if (!_canMoveTo(nextGridX, nextGridY)) {
      return;
    }

    targetGridX = nextGridX;
    targetGridY = nextGridY;
    isMoving = true;
    movementProgress = 0.0;
    pendingDirectionX = null;
    pendingDirectionY = null;
  }

  /// 이동 방향 편의 메서드
  void moveUp() => tryMove(0, -1);
  void moveDown() => tryMove(0, 1);
  void moveLeft() => tryMove(-1, 0);
  void moveRight() => tryMove(1, 0);

  /// 타일 이동 가능 여부 확인
  bool _canMoveTo(int targetX, int targetY) {
    final tile = map.getTile(targetX, targetY);
    if (tile == null) return false;

    // 파괴된 벽은 이동 가능
    if (tile.isDestroyed) return true;

    // 타일 타입별 판정
    switch (tile.type) {
      case TileType.empty:
      case TileType.exit:
      case TileType.item:
        return true;
      case TileType.softWall:
        return tile.isDestroyed;
      case TileType.hardWall:
        return false;
    }
  }

  /// 폭탄 배치 시도
  bool tryPlaceBomb() {
    if (!isAlive) return false;
    if (bombCount >= maxBombs) return false;

    // 현재 타일이 폭탄 배치 가능한지 확인
    final tile = map.getTile(gridX, gridY);
    if (tile == null) return false;

    // 현재 타일이 비어있어야 함 (exit, item도 가능)
    if (tile.type == TileType.hardWall || tile.type == TileType.softWall) {
      return false;
    }

    bombCount++;
    return true;
  }

  /// 폭탄 제거 (폭탄 폭발 후 호출)
  void removeBomb() {
    if (bombCount > 0) {
      bombCount--;
    }
  }

  /// 아이템 획득
  void collectItem(ItemType itemType) {
    switch (itemType) {
      case ItemType.fireUp:
        // 화염 강화: 폭발 범위 +1칸
        fireRange += GameConstants.fireRangeBoost;
        break;
      case ItemType.bombUp:
        // 폭탄 추가: 동시 설치 +1개
        maxBombs += GameConstants.bombCountBoost;
        break;
      case ItemType.speedUp:
        // 신발: 이동 속도 +30%
        speed += GameConstants.speedBoost;
        break;
      case ItemType.timeExtend:
        // 시간 연장: 제한시간 +30초
        // (BombermanGame에서 처리)
        break;
      case ItemType.shield:
        // 신의 가호: 다음 화염 1회 무적
        hasShield = true;
        break;
      case ItemType.curse:
        // 저주: 폭발 범위 -1칸 (최소 1)
        fireRange = (fireRange - 1).clamp(1, 10);
        break;
    }
  }

  /// 무적 효과 사용
  void useShield() {
    if (hasShield) {
      hasShield = false;
    }
  }

  /// 플레이어 사망 (무적 상태 확인)
  void takeDamage() {
    if (hasShield) {
      useShield();
      return; // 무적이면 무적 사용 후 피해 없음
    }
    isAlive = false;
  }

  /// 플레이어 부활
  void respawn(int newGridX, int newGridY) {
    gridX = newGridX;
    gridY = newGridY;
    isAlive = true;
    isMoving = false;
    bombCount = 0;
    pendingDirectionX = null;
    pendingDirectionY = null;
    _updatePosition();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isAlive) return;

    // 이동 처리
    if (isMoving && targetGridX != null && targetGridY != null) {
      // 이동 속도에 따른 진행률 계산
      // speed = 픽셀/초, tileSize = 픽셀/타일
      // 타일당 걸리는 시간 = tileSize / speed
      movementProgress += (speed / GridMap.tileSize) * dt;

      if (movementProgress >= 1.0) {
        // 이동 완료
        gridX = targetGridX!;
        gridY = targetGridY!;
        _updatePosition();
        isMoving = false;
        movementProgress = 0.0;

        // 펜딩 입력 처리
        if (pendingDirectionX != null && pendingDirectionY != null) {
          tryMove(pendingDirectionX!, pendingDirectionY!);
        }
      } else {
        // 이동 중: 선형 보간
        final (currentWorldX, currentWorldY) = map.gridToWorld(gridX, gridY);
        final (targetWorldX, targetWorldY) = map.gridToWorld(targetGridX!, targetGridY!);

        position = Vector2(
          currentWorldX + (targetWorldX - currentWorldX) * movementProgress,
          currentWorldY + (targetWorldY - currentWorldY) * movementProgress,
        );
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (!isAlive) return;

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = size.x / 3;

    // 플레이어를 파란 원으로 렌더링
    final paint = Paint()..color = playerColor;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // 외곽선
    final borderPaint = Paint()
      ..color = playerBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, borderPaint);
  }

  /// 디버그 정보 출력
  String getDebugInfo() {
    return 'Player(${character.name}): Grid($gridX,$gridY) '
        'Speed:$speed Bombs:$bombCount/$maxBombs Fire:$fireRange';
  }
}
