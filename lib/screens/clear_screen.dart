import 'package:flutter/material.dart';
import '../game/constants/game_colors.dart';
import '../managers/localization_manager.dart';
import '../managers/save_manager.dart';

class ClearScreen extends StatelessWidget {
  final int stageNumber;
  final int score;
  final int enemiesDefeated;

  const ClearScreen({
    Key? key,
    required this.stageNumber,
    required this.score,
    required this.enemiesDefeated,
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
                // 클리어 타이틀 (애니메이션)
                Text(
                  loc.get('clear_title'),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: GameColors.success,
                    shadows: [
                      Shadow(
                        color: GameColors.success.withValues(alpha: 0.5),
                        offset: const Offset(0, 0),
                        blurRadius: 12,
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
                      color: GameColors.accent,
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
                        label: loc.get('clear_score', {'score': score.toString()}),
                        value: '$score',
                      ),
                      const SizedBox(height: 16),
                      _infoRow(
                        label: loc.get('clear_enemies', {'count': enemiesDefeated.toString()}),
                        value: '$enemiesDefeated',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // 다음 스테이지 버튼
                _buildButton(
                  label: loc.get('btn_next_stage'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                const SizedBox(height: 16),

                // 메뉴로 버튼
                _buildButton(
                  label: loc.get('btn_menu'),
                  onPressed: () {
                    Navigator.pop(context, false);
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
            color: Color(0xFFFFD700),
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
