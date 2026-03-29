import 'package:flutter/material.dart';
import '../game/constants/game_colors.dart';
import '../managers/localization_manager.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int stageReached;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.stageReached,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();

    return Scaffold(
      backgroundColor: GameColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 게임오버 타이틀
                Text(
                  loc.get('gameover_title'),
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: GameColors.danger,
                    shadows: [
                      Shadow(
                        color: GameColors.danger.withValues(alpha: 0.6),
                        offset: const Offset(0, 0),
                        blurRadius: 16,
                      ),
                    ],
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 32),

                // 점수 정보
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: GameColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: GameColors.danger,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _infoRow(
                        label: loc.get('gameover_score', {'score': score.toString()}),
                        value: '$score',
                      ),
                      const SizedBox(height: 16),
                      _infoRow(
                        label: loc.get('gameover_stage', {'stage': stageReached.toString()}),
                        value: '$stageReached',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // 다시 시작 버튼
                _buildButton(
                  label: loc.get('btn_restart'),
                  onPressed: () {
                    Navigator.pop(context, 'restart');
                  },
                ),
                const SizedBox(height: 16),

                // 메뉴로 버튼
                _buildButton(
                  label: loc.get('btn_menu'),
                  onPressed: () {
                    Navigator.pop(context, 'menu');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFFF4444),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
