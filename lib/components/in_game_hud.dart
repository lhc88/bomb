import 'package:flutter/material.dart';

import '../game/constants/game_colors.dart';
import '../managers/localization_manager.dart';

/// 게임 중 화면 위의 HUD 표시
class InGameHUD extends StatelessWidget {
  final int stageNumber;
  final double remainingTime;
  final int currentScore;
  final Map<String, int> heldItems;

  const InGameHUD({
    Key? key,
    required this.stageNumber,
    required this.remainingTime,
    required this.currentScore,
    required this.heldItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationManager();
    final isTimeWarning = remainingTime <= 30;
    final displayTime = remainingTime.toStringAsFixed(1);

    return Column(
      children: [
        // 상단 정보 바
        Container(
          color: GameColors.blackTransparent(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 좌측: 스테이지 정보
              Text(
                'STAGE $stageNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              // 중앙: 남은 시간
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isTimeWarning
                      ? GameColors.danger.withValues(alpha: 0.8)
                      : GameColors.blackTransparent(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isTimeWarning ? GameColors.danger : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '⏱ ',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '$displayTime s',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: isTimeWarning
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

              // 우측: 현재 점수
              Text(
                '💰 $currentScore',
                style: TextStyle(
                  color: GameColors.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        // 아이템 표시 (있을 경우)
        if (heldItems.isNotEmpty)
          Container(
            color: GameColors.blackTransparent(0.5),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              children: [
                Text(
                  '${loc.get('hud_items')}: ',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                ..._buildItemIcons(loc),
              ],
            ),
          ),
      ],
    );
  }

  /// 아이템 아이콘 목록 빌드
  List<Widget> _buildItemIcons(LocalizationManager loc) {
    final icons = {
      'fireUp': ('🔥', 'hud_item_fireup'),
      'bombUp': ('💣', 'hud_item_bombup'),
      'speedUp': ('⚡', 'hud_item_speedup'),
      'timeExtend': ('⏳', 'hud_item_timeextend'),
      'shield': ('🛡️', 'hud_item_shield'),
      'curse': ('💀', 'hud_item_curse'),
    };

    List<Widget> widgets = [];
    heldItems.forEach((itemType, count) {
      final iconData = icons[itemType];
      if (iconData != null) {
        final itemName = loc.get(iconData.$2);
        widgets.add(
          Tooltip(
            message: '$itemName +$count',
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: GameColors.blackTransparent(0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: GameColors.accent.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Text(
                iconData.$1,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      }
    });

    return widgets;
  }
}
