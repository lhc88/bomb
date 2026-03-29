import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'tile_type.dart';
import '../../utils/constants.dart';

/// 게임 격자 맵
class GridMap extends PositionComponent {
  /// 격자 너비 (가로): 15 타일
  static const int gridWidth = GameConstants.gridWidth;

  /// 격자 높이 (세로): 13 타일
  static const int gridHeight = GameConstants.gridHeight;

  /// 타일 크기: 40px
  static const double tileSize = GameConstants.tileSize;

  /// 격자 데이터 (2D 배열)
  late List<List<Tile>> grid;

  /// 랜덤 생성기
  final Random _random = Random();

  /// 부드러운 벽 밀도 (0.0~1.0)
  final double softWallDensity;

  /// 아이템 드롭 확률 (0.0~1.0)
  final double itemDropRate;

  GridMap({
    this.softWallDensity = 0.3,
    this.itemDropRate = 0.5,
  }) : super(size: Vector2(gridWidth * tileSize, gridHeight * tileSize));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initializeMap();
  }

  /// 맵 초기화
  void _initializeMap() {
    grid = List.generate(
      gridHeight,
      (y) => List.generate(
        gridWidth,
        (x) => _createTile(x, y),
      ),
    );
  }

  /// 타일 생성 로직
  Tile _createTile(int x, int y) {
    // ===== 경계: 단단한 벽 =====
    if (x == 0 || x == gridWidth - 1 || y == 0 || y == gridHeight - 1) {
      return Tile(gridX: x, gridY: y, type: TileType.hardWall);
    }

    // ===== 격자 패턴: 단단한 벽 (짝수 행/열 교차점) =====
    if (x % 2 == 0 && y % 2 == 0) {
      return Tile(gridX: x, gridY: y, type: TileType.hardWall);
    }

    // ===== 플레이어 시작 지점 주변 3칸: 빈 공간 보장 =====
    // 좌상단 (1,1) 주변
    if (x <= 2 && y <= 2) {
      return Tile(gridX: x, gridY: y, type: TileType.empty);
    }
    // 우상단 (13,1) 주변
    if (x >= gridWidth - 3 && y <= 2) {
      return Tile(gridX: x, gridY: y, type: TileType.empty);
    }
    // 좌하단 (1,11) 주변
    if (x <= 2 && y >= gridHeight - 3) {
      return Tile(gridX: x, gridY: y, type: TileType.empty);
    }
    // 우하단 (13,11) 주변
    if (x >= gridWidth - 3 && y >= gridHeight - 3) {
      return Tile(gridX: x, gridY: y, type: TileType.empty);
    }

    // ===== 부드러운 벽: softWallDensity 확률로 배치 =====
    if (_random.nextDouble() < softWallDensity) {
      // itemDropRate 확률로 아이템 포함
      ItemType? item;
      if (_random.nextDouble() < itemDropRate) {
        final itemRoll = _random.nextDouble();
        if (itemRoll < 0.20) {
          // 화염 강화: 폭발 범위 +1칸
          item = ItemType.fireUp;
        } else if (itemRoll < 0.40) {
          // 폭탄 추가: +1개
          item = ItemType.bombUp;
        } else if (itemRoll < 0.60) {
          // 신발: 속도 +30%
          item = ItemType.speedUp;
        } else if (itemRoll < 0.80) {
          // 시간 연장: +30초
          item = ItemType.timeExtend;
        } else if (itemRoll < 0.92) {
          // 신의 가호: 1회 무적 (12%)
          item = ItemType.shield;
        } else {
          // 저주: 범위 -1칸 (8%)
          item = ItemType.curse;
        }
      }

      return Tile(gridX: x, gridY: y, type: TileType.softWall, itemType: item);
    }

    // 나머지: 빈 공간
    return Tile(gridX: x, gridY: y, type: TileType.empty);
  }

  /// 격자 좌표로 타일 가져오기
  Tile? getTile(int gridX, int gridY) {
    if (gridX < 0 || gridX >= gridWidth || gridY < 0 || gridY >= gridHeight) {
      return null;
    }
    return grid[gridY][gridX];
  }

  /// 격자 좌표가 유효한지 확인
  bool isValidGridPosition(int gridX, int gridY) {
    return gridX >= 0 && gridX < width && gridY >= 0 && gridY < height;
  }

  /// 이동 가능 여부 확인
  bool isWalkable(int gridX, int gridY) {
    final tile = getTile(gridX, gridY);
    return tile != null && tile.isWalkable;
  }

  /// 월드 좌표를 격자 좌표로 변환
  (int, int) worldToGrid(double worldX, double worldY) {
    final gridX = (worldX / tileSize).floor();
    final gridY = (worldY / tileSize).floor();
    return (gridX, gridY);
  }

  /// 격자 좌표를 월드 좌표로 변환
  (double, double) gridToWorld(int gridX, int gridY) {
    return (gridX * tileSize, gridY * tileSize);
  }

  /// 타일 파괴
  bool destroyTile(int gridX, int gridY) {
    final tile = getTile(gridX, gridY);
    if (tile != null && tile.canBeDestroyed) {
      tile.destroy();
      return true;
    }
    return false;
  }

  /// 폭발 범위 내의 모든 타일 파괴
  /// 상하좌우 4방향으로 fireRange까지 파괴
  List<(int, int)> destroyTilesInExplosion(
    int centerGridX,
    int centerGridY,
    int fireRange,
  ) {
    List<(int, int)> destroyedTiles = [];

    // 중심 타일
    if (destroyTile(centerGridX, centerGridY)) {
      destroyedTiles.add((centerGridX, centerGridY));
    }

    // 4방향 (상, 하, 좌, 우)
    final directions = [
      (0, -1), // 위
      (0, 1),  // 아래
      (-1, 0), // 왼쪽
      (1, 0),  // 오른쪽
    ];

    for (final (dx, dy) in directions) {
      for (int i = 1; i <= fireRange; i++) {
        final x = centerGridX + (dx * i);
        final y = centerGridY + (dy * i);

        final tile = getTile(x, y);
        if (tile == null || tile.type == TileType.hardWall) {
          break; // 단단한 벽에 막힘
        }

        if (destroyTile(x, y)) {
          destroyedTiles.add((x, y));
          break; // 부드러운 벽을 만나면 그 뒤로 못 간다
        }
      }
    }

    return destroyedTiles;
  }

  /// 폭발 영향 범위 내의 모든 타일 조회
  List<(int, int)> getTilesInExplosion(
    int centerGridX,
    int centerGridY,
    int fireRange,
  ) {
    List<(int, int)> tiles = [];

    // 중심 타일
    tiles.add((centerGridX, centerGridY));

    // 4방향
    final directions = [
      (0, -1), // 위
      (0, 1),  // 아래
      (-1, 0), // 왼쪽
      (1, 0),  // 오른쪽
    ];

    for (final (dx, dy) in directions) {
      for (int i = 1; i <= fireRange; i++) {
        final x = centerGridX + (dx * i);
        final y = centerGridY + (dy * i);

        final tile = getTile(x, y);
        if (tile == null || tile.type == TileType.hardWall) {
          break;
        }

        tiles.add((x, y));

        if (tile.type == TileType.softWall) {
          break;
        }
      }
    }

    return tiles;
  }

  /// 모든 요괴 처치 후 출구 활성화
  void activateExit() {
    for (final row in grid) {
      for (final tile in row) {
        if (tile.type == TileType.exit) {
          tile.activateExit();
        }
      }
    }
  }

  /// 출구 비활성화
  void deactivateExit() {
    for (final row in grid) {
      for (final tile in row) {
        if (tile.type == TileType.exit) {
          tile.deactivateExit();
        }
      }
    }
  }

  /// 맵 리셋
  void reset() {
    _initializeMap();
  }

  /// Flame 렌더링
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 각 타일을 색상 사각형으로 렌더링
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final tile = grid[y][x];
        final rect = Rect.fromLTWH(
          x * tileSize,
          y * tileSize,
          tileSize,
          tileSize,
        );

        // 타일 색상으로 채우기
        final paint = Paint()..color = tile.tileColor;
        canvas.drawRect(rect, paint);

        // 타일 경계선 (디버그용)
        final borderPaint = Paint()
          ..color = const Color.fromARGB(30, 0, 0, 0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawRect(rect, borderPaint);

        // 출구 심볼 렌더링 (활성화된 경우)
        if (tile.type == TileType.exit && tile.isActive) {
          final circlePaint = Paint()..color = const Color(0xFF4CAF50);
          canvas.drawCircle(
            Offset(x * tileSize + tileSize / 2, y * tileSize + tileSize / 2),
            tileSize / 4,
            circlePaint,
          );
        }

        // 아이템 심볼 렌더링
        if (tile.type == TileType.item && !tile.isDestroyed) {
          final itemPaint = Paint()
            ..color = const Color(0xFFFFFFFF)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;
          canvas.drawCircle(
            Offset(x * tileSize + tileSize / 2, y * tileSize + tileSize / 2),
            tileSize / 5,
            itemPaint,
          );
        }
      }
    }
  }

  /// 디버그: 맵 상태 출력
  void printMapDebug() {
    print('=== GridMap Debug Info ===');
    print('Size: $width x $height');
    print('Tile Size: $tileSize px');
    print('Total Tiles: ${width * height}');

    int hardWallCount = 0;
    int softWallCount = 0;
    int emptyCount = 0;
    int itemCount = 0;
    int exitCount = 0;

    for (final row in grid) {
      for (final tile in row) {
        switch (tile.type) {
          case TileType.hardWall:
            hardWallCount++;
          case TileType.softWall:
            softWallCount++;
          case TileType.empty:
            emptyCount++;
          case TileType.item:
            itemCount++;
          case TileType.exit:
            exitCount++;
        }
      }
    }

    print('Hard Walls: $hardWallCount');
    print('Soft Walls: $softWallCount');
    print('Empty: $emptyCount');
    print('Items: $itemCount');
    print('Exits: $exitCount');
  }
}
