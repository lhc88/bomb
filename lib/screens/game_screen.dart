import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game/bomberman_game.dart';
import '../game/data/character_data.dart' as char_data;
import '../managers/localization_manager.dart';
import '../managers/save_manager.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  final int stageNumber;
  final char_data.CharacterData? selectedCharacter;

  const GameScreen({
    Key? key,
    required this.stageNumber,
    this.selectedCharacter,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BombermanGame gameInstance;
  late char_data.CharacterData character;
  bool gameInitialized = false;

  @override
  void initState() {
    super.initState();
    // 캐릭터 로드 (저장된 캐릭터 또는 기본값)
    character = widget.selectedCharacter ?? char_data.Characters.getCharacter(1) ?? char_data.Characters.defaultCharacter();

    // 게임 인스턴스 생성
    gameInstance = BombermanGame(
      selectedCharacter: character,
      stageNumber: widget.stageNumber,
    );
    gameInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();

    if (!gameInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFF1a1a1a),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: Text(
          '${loc.get('stage_label')} ${widget.stageNumber}',
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Center(
              child: Text(
                '시간: ${gameInstance.remainingTime.toStringAsFixed(1)}s',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Flame 게임 영역
          GameWidget(game: gameInstance),

          // 좌측 하단: 방향 D-pad
          Positioned(
            left: 16,
            bottom: 16,
            child: _buildDPad(context),
          ),

          // 우측 하단: 폭탄 버튼
          Positioned(
            right: 16,
            bottom: 16,
            child: _buildBombButton(),
          ),

          // 우측 상단: 게임 정보
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _infoBox(
                  '${loc.get('score_label')}: ${gameInstance.score}',
                ),
                const SizedBox(height: 8),
                _infoBox(
                  '폭탄: ${gameInstance.player.bombCount}/${gameInstance.player.maxBombs}',
                ),
                const SizedBox(height: 8),
                _infoBox(
                  '${loc.get('enemies_label')}: ${gameInstance.enemies.length}',
                ),
              ],
            ),
          ),

          // 게임 상태 오버레이
          if (gameInstance.isStageClear) _buildStageClearOverlay(context, loc),
          if (gameInstance.isGameOver && !gameInstance.isStageClear)
            _buildGameOverOverlay(context, loc),
        ],
      ),
    );
  }

  /// D-pad 구성
  Widget _buildDPad(BuildContext context) {
    const buttonSize = 40.0;
    const spacing = 4.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 위 버튼
        _dpadButton('↑', () {
          gameInstance.handleDirectionInput(0, -1);
        }, size: buttonSize),
        const SizedBox(height: spacing),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 왼쪽 버튼
            _dpadButton('←', () {
              gameInstance.handleDirectionInput(-1, 0);
            }, size: buttonSize),
            const SizedBox(width: spacing),
            // 아래 버튼
            _dpadButton('↓', () {
              gameInstance.handleDirectionInput(0, 1);
            }, size: buttonSize),
            const SizedBox(width: spacing),
            // 오른쪽 버튼
            _dpadButton('→', () {
              gameInstance.handleDirectionInput(1, 0);
            }, size: buttonSize),
          ],
        ),
      ],
    );
  }

  /// D-pad 버튼
  Widget _dpadButton(
    String label,
    VoidCallback onPressed, {
    double size = 40.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 폭탄 버튼
  Widget _buildBombButton() {
    const buttonSize = 60.0;

    return GestureDetector(
      onTap: () {
        gameInstance.handleBombInput();
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B35),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '💣',
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  /// 스테이지 클리어 오버레이
  Widget _buildStageClearOverlay(BuildContext context, LocalizationManager loc) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2d2d2d),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFD700), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.get('clear_title'),
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${loc.get('score_label')}: ${gameInstance.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {'cleared': true, 'score': gameInstance.score});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    child: Text(loc.get('btn_next_stage')),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                    ),
                    child: Text(loc.get('btn_menu')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 게임 오버 오버레이
  Widget _buildGameOverOverlay(BuildContext context, LocalizationManager loc) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2d2d2d),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF44336), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.get('gameover_title'),
                style: const TextStyle(
                  color: Color(0xFFF44336),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${loc.get('score_label')}: ${gameInstance.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                        context,
                        '/game',
                        arguments: {'stageNumber': widget.stageNumber},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                    ),
                    child: Text(loc.get('btn_retry')),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                    ),
                    child: Text(loc.get('btn_menu')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 정보 박스
  Widget _infoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d2d),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD700)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
