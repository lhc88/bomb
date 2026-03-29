import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// 타일 종류 Enum
enum TileType {
  empty,      // 빈 공간 (이동 가능)
  hardWall,   // 단단한 벽 (파괴 불가능)
  softWall,   // 부드러운 벽 (폭탄으로 파괴 가능)
  exit,       // 출구 (모든 요괴 처치 후 활성화)
  item,       // 아이템 (부드러운 벽 파괴 시 생성)
}

/// 아이템 종류 Enum
enum ItemType {
  fireUp,       // 화염 강화: 폭발 범위 +1칸
  bombUp,       // 폭탄 추가: 동시 설치 폭탄 +1개
  speedUp,      // 신발: 이동 속도 +30%
  timeExtend,   // 시간 연장: 제한시간 +30초
  shield,       // 신의 가호: 다음 화염 1회 무적
  curse,        // 저주: 폭발 범위 -1칸 (디버프)
}

/// 타일 클래스
class Tile {
  /// 격자 좌표
  final int gridX;
  final int gridY;

  /// 타일 종류
  TileType type;

  /// 파괴 여부 (softWall만 해당)
  bool isDestroyed = false;

  /// 아이템 정보 (아이템 타일일 때만 사용)
  ItemType? itemType;

  /// 활성화 여부 (exit 타일이 활성화되었는지)
  bool isActive = false;

  Tile({
    required this.gridX,
    required this.gridY,
    required this.type,
    this.itemType,
  });

  /// 이동 가능 여부
  bool get isWalkable {
    if (isDestroyed) return true; // 파괴된 벽은 이동 가능
    return type == TileType.empty || type == TileType.exit || type == TileType.item;
  }

  /// 파괴 가능 여부
  bool get canBeDestroyed => type == TileType.softWall && !isDestroyed;

  /// 타일 색상 (렌더링용)
  Color get tileColor {
    if (isDestroyed) {
      return const Color(0xFF3D2817); // 파괴된 벽 (진갈색)
    }

    switch (type) {
      case TileType.empty:
        return const Color(0xFF2C1810); // 빈 공간 (배경색)
      case TileType.hardWall:
        return const Color(0xFF4A4A4A); // 단단한 벽 (회색)
      case TileType.softWall:
        return const Color(0xFF8B6F47); // 부드러운 벽 (갈색)
      case TileType.exit:
        return isActive ? const Color(0xFFFFD700) : const Color(0xFFB8860B); // 출구 (금색)
      case TileType.item:
        return const Color(0xFFFF6B35); // 아이템 (주황색)
    }
  }

  /// 타일 파괴 (softWall만 파괴 가능)
  void destroy() {
    if (canBeDestroyed) {
      isDestroyed = true;
    }
  }

  /// 출구 활성화
  void activateExit() {
    if (type == TileType.exit) {
      isActive = true;
    }
  }

  /// 출구 비활성화
  void deactivateExit() {
    if (type == TileType.exit) {
      isActive = false;
    }
  }

  /// 타일 정보 문자열
  @override
  String toString() {
    String typeStr = type.toString().split('.').last;
    String state = isDestroyed ? '(destroyed)' : '';
    return '$typeStr($gridX,$gridY)$state';
  }
}
