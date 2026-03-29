import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../data/enemy_data.dart';
import '../map/grid_map.dart';
import '../../utils/constants.dart';

/// 보스 패턴 열거형
enum BossPattern {
  escape,           // 1: 도깨비 대장 - 도망 + 속도 증가
  summonClones,     // 2: 구미호 여왕 - 분신 생성
  poisonCloud,      // 3: 이무기 대왕 - 독 구름
  allOut,           // 4: 치우천왕 - 전체 공격 + 고속
}

/// 보스 컴포넌트
class BossComponent extends PositionComponent {
  /// 보스 데이터
  final EnemyData bossData;

  /// 격자 맵
  final GridMap map;

  /// 플레이어 참조
  final PositionComponent? playerPosition;

  /// 격자 좌표
  late int gridX;
  late int gridY;

  /// HP 관리
  late int currentHp;
  int get maxHp => _getMaxHp();

  /// 이동 타이머
  late double moveTimer;
  late double moveInterval;

  /// 패턴 타이머
  late double patternTimer;

  /// 생존 상태
  bool isAlive = true;

  /// 페이드 아웃 애니메이션
  double fadeOutTimer = 0.0;
  static const double fadeOutDuration = 1.0;

  /// 피격 플래시
  double hitFlashTimer = 0.0;
  static const double hitFlashDuration = 0.3;

  /// 보스 색상
  static const Color bossColor = Color(0xFFFF1744); // 진빨강
  static const Color bossOutlineColor = Color(0xFFFFD700); // 금색

  /// 현재 이동 방향
  int moveDirection = 0;

  /// 속도 배수 (스테이지 진행에 따라 증가)
  late double speedMultiplier;

  BossComponent({
    required this.bossData,
    required this.map,
    required int startGridX,
    required int startGridY,
    this.playerPosition,
    double bosSpeedMultiplier = 1.0,
  }) : super(
    size: Vector2(GridMap.tileSize * 1.5, GridMap.tileSize * 1.5),
  ) {
    speedMultiplier = bosSpeedMultiplier;
    gridX = startGridX;
    gridY = startGridY;
    currentHp = _getMaxHp();
    moveTimer = 0.0;
    moveInterval = 0.4 / speedMultiplier; // 빠른 이동
    patternTimer = 0.0;
    moveDirection = Random().nextInt(4);
    _updatePosition();
  }

  /// 보스 ID별 최대 HP
  int _getMaxHp() {
    switch (bossData.id) {
      case 1: return 5;    // 도깨비 대장
      case 2: return 7;    // 구미호 여왕
      case 3: return 10;   // 이무기 대왕
      case 4: return 15;   // 치우천왕
      default: return 5;
    }
  }

  /// 보스 패턴 결정
  BossPattern get pattern => _getPattern();

  BossPattern _getPattern() {
    switch (bossData.id) {
      case 1: return BossPattern.escape;
      case 2: return BossPattern.summonClones;
      case 3: return BossPattern.poisonCloud;
      case 4: return BossPattern.allOut;
      default: return BossPattern.escape;
    }
  }

  /// 월드 좌표 업데이트
  void _updatePosition() {
    final (worldX, worldY) = map.gridToWorld(gridX, gridY);
    position = Vector2(worldX, worldY);
  }

  /// 플레이어와의 거리
  int _distanceToPlayer() {
    if (playerPosition == null) return 999;
    final (playerGridX, playerGridY) = map.worldToGrid(
      playerPosition!.position.x,
      playerPosition!.position.y,
    );
    return (gridX - playerGridX).abs() + (gridY - playerGridY).abs();
  }

  /// 플레이어 방향
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

  /// 플레이어에서 도망
  (int, int) _escapeFromPlayer() {
    final (dirX, dirY) = _getDirectionToPlayer();

    // 반대 방향으로 이동
    int escapeX = -dirX;
    int escapeY = -dirY;

    if (map.isWalkable(gridX + escapeX, gridY + escapeY)) {
      return (escapeX, escapeY);
    }

    // 실패 시 다른 방향 시도
    final directions = [(0, -1), (0, 1), (-1, 0), (1, 0)];
    for (var (dx, dy) in directions) {
      if (map.isWalkable(gridX + dx, gridY + dy)) {
        return (dx, dy);
      }
    }

    return (0, 0);
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

    // HP 50% 이상 일 때
    bool isHalfHealth = currentHp <= maxHp / 2;

    // 패턴에 따른 이동 속도 조정
    if (pattern == BossPattern.escape && isHalfHealth) {
      moveInterval = 0.2 / speedMultiplier;
    } else if (pattern == BossPattern.allOut && isHalfHealth) {
      moveInterval = 0.2 / speedMultiplier;
    } else {
      moveInterval = 0.4 / speedMultiplier;
    }

    // 이동 업데이트
    moveTimer += dt;
    if (moveTimer >= moveInterval) {
      (int, int) nextMove;

      switch (pattern) {
        case BossPattern.escape:
          nextMove = _escapeFromPlayer();
          break;
        case BossPattern.summonClones:
          nextMove = _chaserMove();
          break;
        case BossPattern.poisonCloud:
          nextMove = _randomMove();
          break;
        case BossPattern.allOut:
          nextMove = _chaserMove();
          break;
      }

      final newX = gridX + nextMove.$1;
      final newY = gridY + nextMove.$2;

      if (map.isValidGridPosition(newX, newY) && map.isWalkable(newX, newY)) {
        gridX = newX;
        gridY = newY;
        _updatePosition();
      }

      moveTimer = 0.0;
    }

    // 패턴 타이머
    patternTimer += dt;

    // 피격 플래시 감소
    if (hitFlashTimer > 0) {
      hitFlashTimer -= dt;
    }
  }

  /// 추적 이동
  (int, int) _chaserMove() {
    final (dirX, dirY) = _getDirectionToPlayer();

    if (dirX != 0 && map.isWalkable(gridX + dirX, gridY)) {
      return (dirX, 0);
    }

    if (dirY != 0 && map.isWalkable(gridX, gridY + dirY)) {
      return (0, dirY);
    }

    return (0, 0);
  }

  /// 랜덤 이동
  (int, int) _randomMove() {
    final directions = [(0, -1), (0, 1), (-1, 0), (1, 0)];

    var (dx, dy) = directions[moveDirection];
    if (map.isWalkable(gridX + dx, gridY + dy)) {
      return (dx, dy);
    }

    moveDirection = Random().nextInt(4);
    var (ndx, ndy) = directions[moveDirection];
    if (map.isWalkable(gridX + ndx, gridY + ndy)) {
      return (ndx, ndy);
    }

    return (0, 0);
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
    return '${bossData.koreanName}($gridX,$gridY) HP:$currentHp/$maxHp Pattern:${pattern.toString()}';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final centerX = width / 2;
    final centerY = height / 2;
    final radius = width / 2.5;

    // 페이드 아웃
    final opacity = (1.0 - (fadeOutTimer / fadeOutDuration)).clamp(0.0, 1.0);
    final opacityInt = (opacity * 255).toInt();

    // 피격 플래시
    final color = hitFlashTimer > 0
        ? Color.fromARGB(opacityInt, 255, 100, 100) // 빨강
        : Color.fromARGB(opacityInt, bossColor.red, bossColor.green, bossColor.blue);

    // 보스 원형
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // 금색 외곽선 (보스 표시)
    final borderPaint = Paint()
      ..color = Color.fromARGB(opacityInt, bossOutlineColor.red, bossOutlineColor.green, bossOutlineColor.blue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, borderPaint);

    // HP 바
    final hpBarWidth = width * 0.9;
    final hpBarHeight = 4.0;
    final hpPercent = currentHp / maxHp;

    // 배경 HP 바
    final hpBgPaint = Paint()..color = Color.fromARGB(opacityInt, 100, 100, 100);
    canvas.drawRect(
      Rect.fromLTWH(
        (width - hpBarWidth) / 2,
        -12,
        hpBarWidth,
        hpBarHeight,
      ),
      hpBgPaint,
    );

    // 체력 HP 바
    final hpFillPaint = Paint()
      ..color = Color.fromARGB(opacityInt, 76, 175, 80);
    canvas.drawRect(
      Rect.fromLTWH(
        (width - hpBarWidth) / 2,
        -12,
        hpBarWidth * hpPercent,
        hpBarHeight,
      ),
      hpFillPaint,
    );

    // HP 텍스트
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${currentHp.toStringAsFixed(0)}/${maxHp}',
        style: TextStyle(
          color: Color.fromARGB(opacityInt, 255, 255, 255),
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        -10 - textPainter.height / 2,
      ),
    );
  }
}
