import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../data/enemy_data.dart';
import '../map/grid_map.dart';
import '../../utils/constants.dart';

/// 요괴 AI 유형
enum EnemyAIType {
  random,        // 1: 도깨비 졸개 - 랜덤 이동
  chaser,        // 2: 도깨비 전사 - 플레이어 추적
  bombAvoider,   // 3: 구미호 - 추적 + 폭탄 회피
  straight,      // 4: 이무기 새끼 - 직선 이동
  fastChaser,    // 5: 천마 - 고속 추적
}

/// 요괴 컴포넌트
class EnemyComponent extends PositionComponent {
  /// 요괴 데이터
  final EnemyData enemyData;

  /// 격자 맵 참조
  final GridMap map;

  /// 플레이어 참조 (추적 AI용)
  final PositionComponent? playerPosition;

  /// 격자 좌표
  late int gridX;
  late int gridY;

  /// HP 관리
  late int currentHp;

  /// 이동 타이머
  late double moveTimer;
  late double moveInterval;

  /// 현재 이동 방향 (직선 이동용)
  late int moveDirection;

  /// 생존 상태
  bool isAlive = true;

  /// 페이드 아웃 애니메이션
  double fadeOutTimer = 0.0;
  static const double fadeOutDuration = 0.5;

  /// 피격 플래시 애니메이션
  double hitFlashTimer = 0.0;
  static const double hitFlashDuration = 0.2;

  /// 요괴 색상
  static const Color enemyColor = Color(0xFFFF6B35); // 주황색
  static const Color enemyOutlineColor = Colors.white;

  /// AI 타입 매핑
  static final Map<int, EnemyAIType> aiTypeMap = {
    1: EnemyAIType.random,        // 도깨비 졸개
    2: EnemyAIType.chaser,        // 도깨비 전사
    3: EnemyAIType.bombAvoider,   // 구미호
    4: EnemyAIType.straight,      // 이무기 새끼
    5: EnemyAIType.fastChaser,    // 천마
  };

  EnemyComponent({
    required this.enemyData,
    required this.map,
    required int startGridX,
    required int startGridY,
    this.playerPosition,
    double speedMultiplier = 1.0,
  }) : super(
    size: Vector2(GridMap.tileSize, GridMap.tileSize),
  ) {
    gridX = startGridX;
    gridY = startGridY;
    currentHp = enemyData.hp;
    moveTimer = 0.0;
    moveInterval = GridMap.tileSize / (enemyData.speed * speedMultiplier);
    moveDirection = Random().nextInt(4);
    _updatePosition();
  }

  /// AI 유형 결정
  EnemyAIType get aiType => aiTypeMap[enemyData.id] ?? EnemyAIType.random;

  /// 월드 좌표 업데이트
  void _updatePosition() {
    final (worldX, worldY) = map.gridToWorld(gridX, gridY);
    position = Vector2(worldX, worldY);
  }

  /// 플레이어와의 거리 계산
  int _distanceToPlayer() {
    if (playerPosition == null) return 999;
    final (playerGridX, playerGridY) = map.worldToGrid(
      playerPosition!.position.x,
      playerPosition!.position.y,
    );
    return (gridX - playerGridX).abs() + (gridY - playerGridY).abs();
  }

  /// 플레이어 방향 계산
  (int, int) _getDirectionToPlayer() {
    if (playerPosition == null) return (0, 0);
    final (playerGridX, playerGridY) = map.worldToGrid(
      playerPosition!.position.x,
      playerPosition!.position.y,
    );

    int dirX = 0;
    int dirY = 0;

    if (playerGridX > gridX) dirX = 1;
    else if (playerGridX < gridX) dirX = -1;

    if (playerGridY > gridY) dirY = 1;
    else if (playerGridY < gridY) dirY = -1;

    return (dirX, dirY);
  }

  /// 다음 이동 위치 결정
  (int, int) _getNextMove() {
    switch (aiType) {
      case EnemyAIType.random:
        // 랜덤 이동
        return _randomMove();

      case EnemyAIType.chaser:
        // 플레이어 추적
        return _chaserMove();

      case EnemyAIType.bombAvoider:
        // 추적 + 폭탄 회피 (50%)
        if (Random().nextDouble() < 0.5) {
          return _chaserMove();
        } else {
          return _randomMove();
        }

      case EnemyAIType.straight:
        // 직선 이동 (한 방향 고집)
        return _straightMove();

      case EnemyAIType.fastChaser:
        // 고속 추적
        return _fastChaserMove();
    }
  }

  /// 랜덤 이동
  (int, int) _randomMove() {
    final directions = [
      (0, -1), // 위
      (0, 1),  // 아래
      (-1, 0), // 왼쪽
      (1, 0),  // 오른쪽
    ];

    // 현재 방향 우선
    var (dx, dy) = directions[moveDirection];
    int newX = gridX + dx;
    int newY = gridY + dy;

    if (map.isWalkable(newX, newY)) {
      return (dx, dy);
    }

    // 다른 방향 시도
    for (int i = 0; i < 4; i++) {
      moveDirection = Random().nextInt(4);
      var (ndx, ndy) = directions[moveDirection];
      newX = gridX + ndx;
      newY = gridY + ndy;
      if (map.isWalkable(newX, newY)) {
        return (ndx, ndy);
      }
    }

    return (0, 0);
  }

  /// 플레이어 추적 이동
  (int, int) _chaserMove() {
    final (dirX, dirY) = _getDirectionToPlayer();

    // 우선 수평 이동 시도
    if (dirX != 0) {
      if (map.isWalkable(gridX + dirX, gridY)) {
        moveDirection = dirX > 0 ? 3 : 2;
        return (dirX, 0);
      }
    }

    // 그 다음 수직 이동 시도
    if (dirY != 0) {
      if (map.isWalkable(gridX, gridY + dirY)) {
        moveDirection = dirY > 0 ? 1 : 0;
        return (0, dirY);
      }
    }

    // 실패 시 랜덤
    return _randomMove();
  }

  /// 직선 이동
  (int, int) _straightMove() {
    final directions = [
      (0, -1), // 위
      (0, 1),  // 아래
      (-1, 0), // 왼쪽
      (1, 0),  // 오른쪽
    ];

    var (dx, dy) = directions[moveDirection];
    int newX = gridX + dx;
    int newY = gridY + dy;

    if (map.isWalkable(newX, newY)) {
      return (dx, dy);
    }

    // 방향 변경
    moveDirection = (moveDirection + 1) % 4;
    var (ndx, ndy) = directions[moveDirection];
    newX = gridX + ndx;
    newY = gridY + ndy;

    if (map.isWalkable(newX, newY)) {
      return (ndx, ndy);
    }

    return (0, 0);
  }

  /// 고속 추적 이동
  (int, int) _fastChaserMove() {
    // 거리 계산
    final distance = _distanceToPlayer();

    // 거리가 충분히 가까우면 추적
    if (distance < 10) {
      return _chaserMove();
    }

    // 멀면 기본 추적
    return _chaserMove();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 페이드 아웃 중
    if (!isAlive) {
      fadeOutTimer += dt;
      if (fadeOutTimer >= fadeOutDuration) {
        removeFromParent();
      }
      return;
    }

    // 이동 타이머
    moveTimer += dt;
    if (moveTimer >= moveInterval) {
      final (dx, dy) = _getNextMove();
      final newX = gridX + dx;
      final newY = gridY + dy;

      if (map.isValidGridPosition(newX, newY) && map.isWalkable(newX, newY)) {
        gridX = newX;
        gridY = newY;
        _updatePosition();
      }

      moveTimer = 0.0;
    }

    // 피격 플래시 타이머 감소
    if (hitFlashTimer > 0) {
      hitFlashTimer -= dt;
    }
  }

  /// 데미지 처리
  void takeDamage(int damage) {
    currentHp -= damage;
    hitFlashTimer = hitFlashDuration;

    if (currentHp <= 0) {
      isAlive = false;
      fadeOutTimer = 0.0;
    }
  }

  /// 디버그 정보
  String getDebugInfo() {
    return '${enemyData.koreanName}($gridX,$gridY) HP:$currentHp AI:${aiType.toString()}';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = size.x / 3;

    // 페이드 아웃 애니메이션
    final opacity = (1.0 - (fadeOutTimer / fadeOutDuration)).clamp(0.0, 1.0);
    final opacityInt = (opacity * 255).toInt();

    // 피격 플래시 효과
    final color = hitFlashTimer > 0
        ? Color.fromARGB(opacityInt, 255, 100, 100) // 빨간색
        : Color.fromARGB(opacityInt, enemyColor.red, enemyColor.green, enemyColor.blue);

    // 요괴 원형으로 렌더링
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // 외곽선
    final borderPaint = Paint()
      ..color = Color.fromARGB(opacityInt, enemyOutlineColor.red, enemyOutlineColor.green, enemyOutlineColor.blue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(centerX, centerY), radius, borderPaint);

    // HP 바 (HP > 1인 경우)
    if (enemyData.hp > 1) {
      final hpBarWidth = size.x * 0.8;
      final hpBarHeight = 2.0;
      final hpPercent = currentHp / enemyData.hp;

      final hpBarPaint = Paint()..color = Color.fromARGB(opacityInt, 100, 100, 100);
      canvas.drawRect(
        Rect.fromLTWH(
          (size.x - hpBarWidth) / 2,
          -8,
          hpBarWidth,
          hpBarHeight,
        ),
        hpBarPaint,
      );

      final hpFillPaint = Paint()..color = Color.fromARGB(opacityInt, 76, 175, 80);
      canvas.drawRect(
        Rect.fromLTWH(
          (size.x - hpBarWidth) / 2,
          -8,
          hpBarWidth * hpPercent,
          hpBarHeight,
        ),
        hpFillPaint,
      );
    }
  }
}
