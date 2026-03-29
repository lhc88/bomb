import 'package:flutter/material.dart';
import '../game/constants/game_colors.dart';
import '../managers/localization_manager.dart';
import '../managers/save_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool soundEnabled;
  late bool musicEnabled;
  late bool vibrationEnabled;

  @override
  void initState() {
    super.initState();
    final settings = SaveManager().loadGameSettings();
    soundEnabled = settings['sound'] ?? true;
    musicEnabled = settings['music'] ?? true;
    vibrationEnabled = settings['vibration'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();

    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        backgroundColor: GameColors.primary,
        title: Text(loc.get('settings_title')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 사운드 설정
          _buildSettingItem(
            title: loc.get('settings_sound'),
            value: soundEnabled,
            onChanged: (value) {
              setState(() {
                soundEnabled = value;
              });
              SaveManager().saveGameSettings(
                soundEnabled: soundEnabled,
                musicEnabled: musicEnabled,
                vibrationEnabled: vibrationEnabled,
              );
            },
          ),
          const SizedBox(height: 16),

          // 음악 설정
          _buildSettingItem(
            title: loc.get('settings_music'),
            value: musicEnabled,
            onChanged: (value) {
              setState(() {
                musicEnabled = value;
              });
              SaveManager().saveGameSettings(
                soundEnabled: soundEnabled,
                musicEnabled: musicEnabled,
                vibrationEnabled: vibrationEnabled,
              );
            },
          ),
          const SizedBox(height: 16),

          // 진동 설정
          _buildSettingItem(
            title: loc.get('settings_vibration'),
            value: vibrationEnabled,
            onChanged: (value) {
              setState(() {
                vibrationEnabled = value;
              });
              SaveManager().saveGameSettings(
                soundEnabled: soundEnabled,
                musicEnabled: musicEnabled,
                vibrationEnabled: vibrationEnabled,
              );
            },
          ),
          const SizedBox(height: 32),

          // 게임 초기화 버튼
          ElevatedButton(
            onPressed: () {
              _showResetDialog(context, loc);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4444),
            ),
            child: Text(loc.get('btn_reset_game')),
          ),
          const SizedBox(height: 16),

          // 정보
          Center(
            child: Text(
              'Sinsi Bomber v1.0',
              style: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final loc = LocalizationManager();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d2d),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF8B0000),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, LocalizationManager loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: Text(
          loc.get('btn_reset_game'),
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        content: Text(
          '게임을 초기화하시겠습니까?',
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.get('cancel'),
              style: const TextStyle(color: Color(0xFF8B0000)),
            ),
          ),
          TextButton(
            onPressed: () {
              SaveManager().resetGameProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('게임이 초기화되었습니다.')),
              );
            },
            child: Text(
              loc.get('ok'),
              style: const TextStyle(color: Color(0xFFFF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
