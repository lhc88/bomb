import 'package:flutter/material.dart';
import '../game/constants/game_colors.dart';
import '../managers/localization_manager.dart';
import '../managers/save_manager.dart';
import '../managers/sound_manager.dart';
import 'game_screen.dart';
import 'character_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int highScore;

  @override
  void initState() {
    super.initState();
    highScore = SaveManager().loadTotalScore();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();

    return Scaffold(
      backgroundColor: GameColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 타이틀
                  Text(
                    loc.get('main_title'),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: GameColors.primary,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.get('main_subtitle'),
                    style: TextStyle(
                      fontSize: 18,
                      color: GameColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 하이스코어
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: GameColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: GameColors.accent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: GameColors.accent.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '👑 ',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          loc.get('btn_high_score', {'score': highScore.toString()}),
                          style: TextStyle(
                            fontSize: 20,
                            color: GameColors.accent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 게임 시작 버튼
                  _buildButton(
                    label: loc.get('btn_start_game'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(stageNumber: 1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 캐릭터 선택 버튼
                  _buildButton(
                    label: loc.get('btn_select_character'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CharacterScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 설정 버튼
                  _buildButton(
                    label: loc.get('btn_settings'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        onPressed: () {
          SoundManager().vibrateLight();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: GameColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: GameColors.accent,
              width: 2,
            ),
          ),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: GameColors.textPrimary,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
