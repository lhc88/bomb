import 'package:flutter/material.dart';

import '../game/constants/game_colors.dart';
import '../game/data/stage_data.dart';
import '../managers/localization_manager.dart';
import '../managers/save_manager.dart';

/// 스테이지 선택 화면
class StageSelectionScreen extends StatefulWidget {
  const StageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<StageSelectionScreen> createState() => _StageSelectionScreenState();
}

class _StageSelectionScreenState extends State<StageSelectionScreen> {
  int selectedWorldIndex = 0;
  late List<String> worldNames;
  late List<String> worldDescriptions;

  @override
  void initState() {
    super.initState();
    final loc = LocalizationManager();
    worldNames = [
      loc.get('world_1'),
      loc.get('world_2'),
      loc.get('world_3'),
      loc.get('world_4'),
    ];
    worldDescriptions = [
      loc.get('world_1_desc'),
      loc.get('world_2_desc'),
      loc.get('world_3_desc'),
      loc.get('world_4_desc'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();

    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        backgroundColor: GameColors.primary,
        title: Text(
          loc.get('stage_select_title'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 월드 탭
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: const Color(0xFF0d0d0d),
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: worldNames.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedWorldIndex == index;
                  return _buildWorldTab(index, isSelected);
                },
              ),
            ),
          ),

          // 스테이지 그리드
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                final stageNumber = selectedWorldIndex * 10 + index + 1;
                final stage = Stages.getStage(stageNumber);
                final isCleared = SaveManager().isStageClear(stageNumber);
                final stars = SaveManager().getStageStar(stageNumber);
                final isUnlocked = isCleared || stageNumber <= 1; // 첫 스테이지는 자동 해금

                if (stage == null) {
                  return const SizedBox.shrink();
                }

                return _buildStageButton(
                  context,
                  stage,
                  isUnlocked,
                  isCleared,
                  stars,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 월드 탭 빌드
  Widget _buildWorldTab(int worldIndex, bool isSelected) {
    final worldIcon = ['🏯', '👹', '🐉', '✨'][worldIndex];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWorldIndex = worldIndex;
        });
      },
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B0000) : const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              worldIcon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              worldNames[worldIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFD700) : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 스테이지 버튼 빌드
  Widget _buildStageButton(
    BuildContext context,
    StageData stage,
    bool isUnlocked,
    bool isCleared,
    int stars,
  ) {
    final isBossStage = stage.isBossStage;

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.pop(context, stage);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isBossStage ? const Color(0xFF660000) : const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCleared ? const Color(0xFFFFD700) : Colors.transparent,
            width: isCleared ? 2 : 1,
          ),
          boxShadow: isCleared
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha:0.3),
                    blurRadius: 6,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // 스테이지 정보
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'STAGE',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '${stage.stageNumber}',
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isBossStage)
                    const Text(
                      '👹',
                      style: TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),

            // 자물쇠 아이콘 (미해금)
            if (!isUnlocked)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // 별점 표시 (클리어됨)
            if (isCleared && stars > 0)
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Text(
                      i < stars ? '⭐' : '☆',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
