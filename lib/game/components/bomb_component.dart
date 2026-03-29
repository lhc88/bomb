import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../map/grid_map.dart';
import '../../utils/constants.dart';

/// 폭탄 컴포넌트
class BombComponent extends PositionComponent {
  /// 격자 좌표
  final int gridX;
  final int gridY;

  /// 격자 맵 참조
  final GridMap map;

  /// 폭발 범위
  final int fireRange;

  /// 폭발 콜백 (centerX, centerY, fireRange)
  final Function(int, int, int) onExplode;

  /// 폭탄 타이머
  late double explosionTimer;
  bool hasExploded = false;

  /// 폭탄 색상
  static const Color bombColor = Color(0xFF1A1A1A); // 검은색
  static const Color bombBlinkColor = Color(0xFFFF0000); // 빨간색 (깜빡임)

  BombComponent({
    required this.gridX,
    required this.gridY,
    required this.map,
    required this.fireRange,
    required this.onExplode,
  }) : super(
    size: Vector2(GridMap.tileSize, GridMap.tileSize),
  ) {
    explosionTimer = 0.0;
    _updatePosition();
  }

  /// 월드 좌표 업데이트
  void _updatePosition() {
    final (worldX, worldY) = map.gridToWorld(gridX, gridY);
    position = Vector2(worldX, worldY);
  }

  /// 폭탄이 현재 타일을 차단하는지 확인
  bool blocksPosition(int checkGridX, int checkGridY) {
    return gridX == checkGridX && gridY == checkGridY;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (hasExploded) return;

    explosionTimer += dt;

    // 폭탄 폭발 시간 도달
    if (explosionTimer >= GameConstants.bombExplosionDelay) {
      explode();
    }
  }

  /// 폭탄 폭발
  void explode() {
    if (hasExploded) return;
    hasExploded = true;

    // 폭발 콜백 실행
    onExplode(gridX, gridY, fireRange);

    // 폭탄 제거 (부모 컴포넌트가 처리)
    removeFromParent();
  }

  /// 폭탄 깜빡임 상태 확인 (0.2초 간격)
  bool get isBlinking {
    final blinkInterval = GameConstants.bombBlinkInterval;
    final totalBlinks = GameConstants.bombExplosionDelay / blinkInterval;
    final currentBlink = (explosionTimer / blinkInterval).floor();
    return currentBlink % 2 == 1; // 홀수 번째 깜빡임에서 true
  }

  /// 남은 폭발 시간 (초)
  double get remainingTime {
    return (GameConstants.bombExplosionDelay - explosionTimer).clamp(0.0, GameConstants.bombExplosionDelay);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (hasExploded) return;

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = size.x / 2.5;

    // 폭탄 색상 결정 (깜빡임 애니메이션)
    final bombPaint = Paint()
      ..color = isBlinking ? bombBlinkColor : bombColor;

    // 폭탄 원형으로 렌더링
    canvas.drawCircle(Offset(centerX, centerY), radius, bombPaint);

    // 외곽선
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, borderPaint);

    // 폭탄 위에 타이머 숫자 표시 (선택사항)
    final remaining = remainingTime.toStringAsFixed(1);
    final textPainter = TextPainter(
      text: TextSpan(
        text: remaining,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  /// 디버그 정보
  String getDebugInfo() {
    return 'Bomb($gridX,$gridY) Timer:${explosionTimer.toStringAsFixed(2)}/'
        '${GameConstants.bombExplosionDelay} Fire:$fireRange';
  }
}
