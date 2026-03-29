import 'package:flutter/material.dart';

import '../game/constants/game_colors.dart';
import '../game/data/character_data.dart' as char_data;
import '../managers/localization_manager.dart';
import '../managers/save_manager.dart';

/// 캐릭터 선택 화면
class CharacterScreen extends StatefulWidget {
  const CharacterScreen({Key? key}) : super(key: key);

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late int selectedCharacterId;

  @override
  void initState() {
    super.initState();
    // 저장된 선택 캐릭터 로드
    selectedCharacterId = SaveManager().loadSelectedCharacter();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();

    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        backgroundColor: GameColors.primary,
        title: Text(
          loc.get('character_select_title'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 캐릭터 그리드 (2열)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: char_data.Characters.all.length,
              itemBuilder: (context, index) {
                final character = char_data.Characters.all[index];
                final isSelected = selectedCharacterId == character.id;

                return _buildCharacterCard(
                  context,
                  character,
                  isSelected,
                  loc,
                );
              },
            ),
          ),

          // 선택 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final character = char_data.Characters.getCharacter(selectedCharacterId);
                  if (character != null && character.isUnlocked) {
                    SaveManager().saveSelectedCharacter(selectedCharacterId);
                    Navigator.pop(context, character);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  loc.get('btn_select'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 캐릭터 카드 빌드
  Widget _buildCharacterCard(
    BuildContext context,
    char_data.CharacterData character,
    bool isSelected,
    LocalizationManager loc,
  ) {
    return GestureDetector(
      onTap: character.isUnlocked
          ? () {
              setState(() {
                selectedCharacterId = character.id;
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // 카드 내용
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 캐릭터 아이콘 (첫 글자)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      character.koreanName[0],
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 캐릭터 이름
                Text(
                  character.koreanName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // 능력치 바
                if (character.isUnlocked)
                  Column(
                    children: [
                      _buildStatBar('범위', character.bombRange, 6),
                      const SizedBox(height: 3),
                      _buildStatBar('폭탄', character.bombCount, 5),
                      const SizedBox(height: 3),
                      _buildStatBar('속도', _getSpeedLevel(character.speed), 4),
                      const SizedBox(height: 3),
                      _buildStatBar('지연', _getDelayLevel(character.fuseTime), 4),
                    ],
                  )
                else
                  Text(
                    '${character.unlockCondition}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFFF9800),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),

            // 잠금 아이콘
            if (!character.isUnlocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

            // 구매 태그
            if (character.unlockType == 'purchase')
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '₩${character.unlockValue}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // 광고 해금 태그
            if (character.unlockType == 'watchAd' && !character.isUnlocked)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    '광고 해금',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 능력치 바 빌드
  Widget _buildStatBar(String label, int value, int maxValue) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 9,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor: const Color(0xFF444444),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 속도를 레벨로 변환 (1~4)
  int _getSpeedLevel(double speed) {
    if (speed <= 100) return 1;      // slow
    if (speed <= 130) return 2;      // normal
    if (speed <= 150) return 3;      // fast
    return 4;                         // veryFast
  }

  /// 지연시간을 레벨로 변환 (1~4, 역순: 1초=4, 3초=1)
  int _getDelayLevel(double fuseTime) {
    if (fuseTime >= 3.0) return 1;
    if (fuseTime >= 2.5) return 2;
    if (fuseTime >= 1.5) return 3;
    return 4;
  }
}
