import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/player_component.dart';
import 'components/bomb_component.dart';
import 'components/explosion_component.dart';
import 'components/enemy_component.dart';
import 'components/boss_component.dart';
import 'map/grid_map.dart';
import 'map/tile_type.dart';
import 'data/stage_data.dart';
import 'data/character_data.dart';
import 'data/enemy_data.dart';
import '../utils/constants.dart';
import '../components/tutorial_overlay.dart';
import '../managers/save_manager.dart';

/// 게임 상태
enum GameStatus {
  playing, // 게임 중
  stageClear, // 스테이지 클리어
  gameOver, // 게임 오버
}

/// 봄버맨 메인 게임 클래스
class BombermanGame extends FlameGame {
  /// 게임 맵
  late GridMap gridMap;

  /// 플레이어
  late PlayerComponent player;

  /// 선택된 캐릭터 데이터
  final CharacterData selectedCharacter;

  /// 현재 스테이지 데이터
  late StageData currentStage;

  /// 적 목록
  final List<EnemyComponent> enemies = [];

  /// 폭탄 목록
  final List<BombComponent> bombs = [];

  /// 폭발 목록
  final List<ExplosionComponent> explosions = [];

  /// 게임 상태
  GameStatus gameStatus = GameStatus.playing;

  /// 점수
  int score = 0;

  /// 처치한 적 수
  int enemiesDefeated = 0;

  /// 남은 시간 (초)
  late double remainingTime;

  /// 스테이지 번호
  final int stageNumber;

  /// 튜토리얼 활성화 여부
  late bool isTutorialActive;

  /// 튜토리얼 오버레이
  late TutorialOverlay? tutorialOverlay;

  /// 튜토리얼 상태 추적
  final Map<TutorialStep, bool> tutorialStepCompleted = {
    TutorialStep.movement: false,
    TutorialStep.bombPlacement: false,
    TutorialStep.escape: false,
    TutorialStep.enemyDefeat: false,
    TutorialStep.exit: false,
  };

  /// 플레이어 초기 위치 (튜토리얼용)
  late int playerStartX;
  late int playerStartY;

  /// 요괴 초기 수 (튜토리얼용)
  late int initialEnemyCount;

  BombermanGame({
    required this.selectedCharacter,
    required this.stageNumber,
  }) {
    currentStage = Stages.getStage(stageNumber) ?? Stages.getStage(1)!;
    remainingTime = currentStage.timeLimit.toDouble();
    isTutorialActive = false;
    tutorialOverlay = null;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 맵 초기화 (밸런스 적용)
    gridMap = GridMap(
      softWallDensity: currentStage.softWallDensity,
      itemDropRate: currentStage.itemDropRate,
    );

    // 카메라 줌 설정
    camera.viewfinder.zoom = 1.2;

    // 플레이어 생성 (좌상단 시작)
    player = PlayerComponent(
      character: selectedCharacter,
      map: gridMap,
      startGridX: 1,
      startGridY: 1,
    );
    add(player);

    // 맵 추가
    add(gridMap);

    // 요괴 생성
    _spawnEnemies();
    initialEnemyCount = enemies.length;

    // 플레이어 초기 위치 저장 (튜토리얼용)
    playerStartX = player.gridX;
    playerStartY = player.gridY;

    // 출구 비활성화 (모든 적 처치 후 활성화)
    gridMap.deactivateExit();

    // 튜토리얼 초기화 (스테이지 1에서만, 첫 플레이 시에만)
    _initializeTutorial();
  }

  /// 튜토리얼 초기화
  Future<void> _initializeTutorial() async {
    // 스테이지 1이고 튜토리얼을 안 봤으면 표시
    if (stageNumber == 1) {
      final tutorialCompleted = SaveManager().loadTutorialCompleted();
      if (!tutorialCompleted) {
        isTutorialActive = true;
        tutorialOverlay = TutorialOverlay(
          currentStep: TutorialStep.movement,
          onStepChanged: (step) {
            // 단계 변경 시 처리 (필요시)
            print('튜토리얼 단계: $step');
          },
          onTutorialCompleted: () async {
            isTutorialActive = false;
            await SaveManager().saveTutorialCompleted(true);
            print('튜토리얼 완료!');
          },
        );
        add(tutorialOverlay!);
      }
    }
  }

  /// 요괴 생성
  void _spawnEnemies() {
    final int enemyCount = currentStage.getEnemyCount();

    for (int i = 0; i < enemyCount; i++) {
      int gridX = (i % 3) * 4 + 7;
      int gridY = (i ~/ 3) * 4 + 7;

      // 맵 범위 확인
      if (gridX >= GridMap.gridWidth || gridY >= GridMap.gridHeight) continue;

      if (gridMap.isWalkable(gridX, gridY)) {
        final enemyData = Enemies.getRandomEnemy();
        final enemy = EnemyComponent(
          enemyData: enemyData,
          map: gridMap,
          startGridX: gridX,
          startGridY: gridY,
          speedMultiplier: currentStage.enemySpeed,
        );
        enemies.add(enemy);
        add(enemy);
      }
    }

    // 보스 스테이지 처리
    if (currentStage.isBossStage) {
      final bossData = Enemies.getEnemy(3); // 구미호
      if (bossData != null && gridMap.isWalkable(7, 6)) {
        final boss = BossComponent(
          bossData: bossData,
          map: gridMap,
          startGridX: 7,
          startGridY: 6,
          bosSpeedMultiplier: currentStage.enemySpeed,
        );
        add(boss);
      }
    }
  }

  /// 폭탄 배치
  void placeBomb() {
    if (!player.tryPlaceBomb()) return;

    late final BombComponent bomb;
    bomb = BombComponent(
      gridX: player.gridX,
      gridY: player.gridY,
      map: gridMap,
      fireRange: player.fireRange,
      onExplode: (centerX, centerY, fireRange) {
        _handleExplosion(centerX, centerY, fireRange, bomb);
      },
    );
    bombs.add(bomb);
    add(bomb);
  }

  /// 폭발 처리
  void _handleExplosion(int centerX, int centerY, int fireRange, BombComponent bomb) {
    // 폭발 컴포넌트 생성
    final explosion = ExplosionComponent(
      centerGridX: centerX,
      centerGridY: centerY,
      fireRange: fireRange,
      map: gridMap,
    );
    explosions.add(explosion);
    add(explosion);

    // 연쇄 폭발: 폭발 범위 내의 다른 폭탄도 함께 폭발
    final bombsToExplode = <BombComponent>[];
    for (final otherBomb in bombs) {
      if (otherBomb != bomb &&
          explosion.isAffected(otherBomb.gridX, otherBomb.gridY)) {
        bombsToExplode.add(otherBomb);
      }
    }

    // 연쇄 폭발 처리 (즉시 폭발하지 않고 콜백으로 처리)
    for (final chainBomb in bombsToExplode) {
      if (!chainBomb.hasExploded) {
        chainBomb.explode();
      }
    }

    // 적 피해 처리
    for (final enemy in enemies) {
      if (explosion.isAffected(enemy.gridX, enemy.gridY)) {
        enemy.takeDamage(1);
        if (!enemy.isAlive) {
          enemiesDefeated++;
          score += GameConstants.scorePerEnemy;
          enemy.removeFromParent();
        }
      }
    }

    // 플레이어 피해 처리
    if (explosion.isAffected(player.gridX, player.gridY)) {
      player.takeDamage();
      if (!player.isAlive) {
        gameStatus = GameStatus.gameOver;
      }
    }

    // 폭탄 제거
    player.removeBomb();
    bombs.removeWhere((b) => b == bomb);
  }

  /// 입력 처리 - 방향
  void handleDirectionInput(int dirX, int dirY) {
    if (gameStatus != GameStatus.playing) return;
    player.tryMove(dirX, dirY);
  }

  /// 입력 처리 - 폭탄
  void handleBombInput() {
    if (gameStatus != GameStatus.playing) return;
    placeBomb();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameStatus != GameStatus.playing) return;

    // 시간 업데이트
    remainingTime -= dt;
    if (remainingTime <= 0) {
      gameStatus = GameStatus.gameOver;
      return;
    }

    // 튜토리얼 진행 체크
    if (isTutorialActive && tutorialOverlay != null) {
      _updateTutorialProgress();
    }

    // 아이템 수집 확인
    _checkItemCollection();

    // 스테이지 클리어 조건 확인
    if (enemies.isEmpty && gameStatus == GameStatus.playing) {
      // 출구 활성화
      gridMap.activateExit();

      // 플레이어가 출구에 있는지 확인
      final exitTile = gridMap.getTile(player.gridX, player.gridY);
      if (exitTile?.type == TileType.exit && exitTile?.isActive == true) {
        gameStatus = GameStatus.stageClear;
      }
    }
  }

  /// 아이템 수집 확인
  void _checkItemCollection() {
    final tile = gridMap.getTile(player.gridX, player.gridY);
    if (tile != null && tile.itemType != null && tile.isDestroyed) {
      // 파괴된 벽에 아이템이 있으면 수집
      final itemType = tile.itemType!;

      // 아이템별 효과 처리
      if (itemType == ItemType.timeExtend) {
        // 시간 연장: +30초
        remainingTime += 30.0;
      } else {
        // 다른 아이템: 플레이어가 처리
        player.collectItem(itemType);
      }

      // 아이템 제거 (더 이상 획득 불가)
      tile.itemType = null;
    }
  }

  /// 튜토리얼 진행 상황 업데이트
  void _updateTutorialProgress() {
    if (tutorialOverlay == null) return;

    final currentStep = tutorialOverlay!.currentStep;

    // 각 단계별 조건 확인
    switch (currentStep) {
      case TutorialStep.movement:
        // 플레이어가 시작 위치에서 움직였는가
        if (player.gridX != playerStartX || player.gridY != playerStartY) {
          tutorialStepCompleted[TutorialStep.movement] = true;
          tutorialOverlay!.nextStep();
        }
        break;

      case TutorialStep.bombPlacement:
        // 폭탄이 설치되었는가
        if (bombs.isNotEmpty) {
          tutorialStepCompleted[TutorialStep.bombPlacement] = true;
          tutorialOverlay!.nextStep();
        }
        break;

      case TutorialStep.escape:
        // 폭발이 발생했는가
        if (explosions.isNotEmpty) {
          tutorialStepCompleted[TutorialStep.escape] = true;
          tutorialOverlay!.nextStep();
        }
        break;

      case TutorialStep.enemyDefeat:
        // 요괴가 처치되었는가
        if (enemiesDefeated > 0) {
          tutorialStepCompleted[TutorialStep.enemyDefeat] = true;
          tutorialOverlay!.nextStep();
        }
        break;

      case TutorialStep.exit:
        // 출구가 활성화되었는가 (자동으로 이전 단계에서 처리)
        // 이 단계는 탭으로 건너뛰기만 가능
        break;
    }
  }

  /// 게임 상태 조회
  bool get isGameOver => gameStatus == GameStatus.gameOver;
  bool get isStageClear => gameStatus == GameStatus.stageClear;
  bool get isPlaying => gameStatus == GameStatus.playing;

  /// 디버그 정보
  void printDebugInfo() {
    print('=== BombermanGame Debug ===');
    print('Status: $gameStatus');
    print('Score: $score');
    print('Enemies: ${enemies.length}');
    print('Bombs: ${bombs.length}');
    print('Time: ${remainingTime.toStringAsFixed(1)}s');
    print(player.getDebugInfo());
  }
}
