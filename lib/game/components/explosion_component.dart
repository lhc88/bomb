import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../map/grid_map.dart';
import '../map/tile_type.dart';
import '../../utils/constants.dart';

/// 폭발 컴포넌트
class ExplosionComponent extends PositionComponent {
  /// 중심 격자 좌표
  final int centerGridX;
  final int centerGridY;

  /// 폭발 범위
  final int fireRange;

  /// 격자 맵 참조
  final GridMap map;

  /// 폭발 지속 시간
  late double lifeTime;

  /// 폭발에 영향을 받는 타일 목록
  late List<(int, int)> affectedTiles;

  /// 폭발 색상
  static const Color explosionColor = Color(0xFFFF6B35); // 주황색

  ExplosionComponent({
    required this.centerGridX,
    required this.centerGridY,
    required this.fireRange,
    required this.map,
  }) : super(
    size: Vector2(GridMap.tileSize, GridMap.tileSize),
  ) {
    lifeTime = 0.0;
    // 폭발 범위 타일 계산 및 파괴
    affectedTiles = map.destroyTilesInExplosion(centerGridX, centerGridY, fireRange);
    _updatePosition();
  }

  /// 월드 좌표 업데이트
  void _updatePosition() {
    final (worldX, worldY) = map.gridToWorld(centerGridX, centerGridY);
    position = Vector2(worldX, worldY);
  }

  /// 특정 격자 위치가 폭발에 영향을 받는지 확인
  bool isAffected(int gridX, int gridY) {
    return affectedTiles.any((tile) => tile.$1 == gridX && tile.$2 == gridY);
  }

  /// 폭발 진행률 (0.0 ~ 1.0)
  double get progress => (lifeTime / GameConstants.explosionDuration).clamp(0.0, 1.0);

  /// 폭발 불투명도 (페이드 아웃)
  double get opacity => 1.0 - progress;

  @override
  void update(double dt) {
    super.update(dt);
    lifeTime += dt;

    // 지속 시간 종료 시 제거
    if (lifeTime >= GameConstants.explosionDuration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final opacityValue = (opacity * 255).toInt().clamp(0, 255);
    final paint = Paint()
      ..color = Color.fromARGB(opacityValue, explosionColor.red, explosionColor.green, explosionColor.blue);

    final centerX = size.x / 2;
    final centerY = size.y / 2;

    // 중심 타일에 원형 폭발 표시
    canvas.drawCircle(Offset(centerX, centerY), size.x / 2.5, paint);

    // 각 영향을 받는 타일에 사각형 표시
    for (final (x, y) in affectedTiles) {
      final (worldX, worldY) = map.gridToWorld(x, y);

      // 현재 컴포넌트 위치 기준 상대 좌표로 변환
      final relativeX = worldX - position.x;
      final relativeY = worldY - position.y;

      // 폭발 이펙트 사각형
      canvas.drawRect(
        Rect.fromLTWH(relativeX, relativeY, GridMap.tileSize, GridMap.tileSize),
        paint,
      );

      // 프레임 강조 (중심일 경우 더 밝게)
      if (x == centerGridX && y == centerGridY) {
        final highlightPaint = Paint()
          ..color = Color.fromARGB(opacityValue ~/ 2, explosionColor.red, explosionColor.green, explosionColor.blue)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawRect(
          Rect.fromLTWH(relativeX, relativeY, GridMap.tileSize, GridMap.tileSize),
          highlightPaint,
        );
      }
    }
  }

  /// 디버그 정보
  String getDebugInfo() {
    return 'Explosion($centerGridX,$centerGridY) Range:$fireRange '
        'Affected:${affectedTiles.length} Life:${lifeTime.toStringAsFixed(2)}/'
        '${GameConstants.explosionDuration}';
  }
}
