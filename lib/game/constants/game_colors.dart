import 'package:flutter/material.dart';

/// 게임 비주얼 색상 정의 (GDD 8장)
class GameColors {
  // 배경색
  static const Color background = Color(0xFF2C1810); // 어두운 갈색
  static const Color darkBackground = Color(0xFF1a1a1a); // UI 배경

  // 벽 색상
  static const Color solidWall = Color(0xFF4A2810); // 단단한 벽
  static const Color softWall = Color(0xFF8B4513); // 부드러운 벽
  static const Color emptySpace = Color(0xFF3A2010); // 빈 공간
  static const Color checkPattern = Color(0xFF4A3020); // 체크 패턴 어두운 부분

  // UI 색상
  static const Color primary = Color(0xFF8B0000); // 진홍색 (AppBar)
  static const Color accent = Color(0xFFFFD700); // 금색 (강조)
  static const Color success = Color(0xFF4CAF50); // 초록색 (성공)
  static const Color danger = Color(0xFFFF6B6B); // 빨강 (경고)
  static const Color warning = Color(0xFFFF9800); // 주황색 (알림)

  // 텍스트 색상
  static const Color textPrimary = Color(0xFFFFFFFF); // 흰색
  static const Color textSecondary = Color(0xFFBBBBBB); // 밝은 회색
  static const Color textDisabled = Color(0xFF666666); // 어두운 회색

  // 폭탄 색상
  static const Color bombBody = Color(0xFF1A1A1A); // 폭탄 본체
  static const Color bombFuse = Color(0xFFFF2020); // 폭탄 도화선
  static const Color bombLight = Color(0xFFFFFF00); // 폭탄 불빛

  // 화염 색상 (그라데이션)
  static const Color flameStart = Color(0xFFFF6600); // 화염 시작 (주황)
  static const Color flameEnd = Color(0xFFFFD700); // 화염 끝 (금색)

  // 플레이어 색상 (캐릭터별 고유)
  static const Color playerDefault = Color(0xFF4CAF50); // 기본 플레이어
  static const Color playerBari = Color(0xFFE91E63); // 바리데기 (분홍)
  static const Color playerJumong = Color(0xFF2196F3); // 주몽 (파랑)
  static const Color playerSondok = Color(0xFF9C27B0); // 선덕여왕 (보라)
  static const Color playerUlji = Color(0xFFFF9800); // 을지문덕 (주황)
  static const Color playerYeonorang = Color(0xFF00BCD4); // 연오랑 (청록)
  static const Color playerOndal = Color(0xFF795548); // 온달 (갈색)
  static const Color playerGwanggaeto = Color(0xFFFF5722); // 광개토대왕 (빨강)
  static const Color playerHwanung = Color(0xFFFFEB3B); // 환웅 (노랑)
  static const Color playerDangun = Color(0xFF4A90E2); // 단군왕검 (진파랑)

  // 요괴 색상 (각 타입별 한국 신화 컬러)
  static const Color enemyGoblin = Color(0xFF8B0000); // 도깨비 (진홍)
  static const Color enemyGumiho = Color(0xFFFF6B9D); // 구미호 (연분홍)
  static const Color enemyImugi = Color(0xFF1A472A); // 이무기 (짙은 녹색)
  static const Color enemyTenma = Color(0xFF6A5ACD); // 천마 (보라)

  // 보스 색상
  static const Color bossGoblin = Color(0xFFDC143C); // 도깨비 대장 (진빨강)
  static const Color bossGumiho = Color(0xFFFF1493); // 구미호 여왕 (진핑크)
  static const Color bossImugi = Color(0xFF228B22); // 이무기 대왕 (숲색)
  static const Color bossChiyou = Color(0xFF000000); // 치우천왕 (검정)

  // 아이템 색상
  static const Color itemFireUp = Color(0xFFFF6600); // 범위 증가 (주황)
  static const Color itemBombUp = Color(0xFF1A1A1A); // 폭탄 증가 (검정)
  static const Color itemSpeedUp = Color(0xFF00FF00); // 속도 증가 (초록)
  static const Color itemTimeExtend = Color(0xFF0099FF); // 시간 연장 (파랑)
  static const Color itemShield = Color(0xFFFFD700); // 방패 (금색)
  static const Color itemCurse = Color(0xFF800080); // 저주 (보라)

  // 카드 색상
  static const Color cardBackground = Color(0xFF2d2d2d); // 카드 배경
  static const Color cardBorder = Color(0xFF444444); // 카드 테두리
  static const Color cardHighlight = Color(0xFFFFD700); // 카드 강조

  // 상태 색상
  static const Color hpFull = Color(0xFF4CAF50); // 체력 만
  static const Color hpHalf = Color(0xFFFFD700); // 체력 절반
  static const Color hpCritical = Color(0xFFFF6B6B); // 체력 위험

  // 그라데이션 색상
  static const List<Color> flameGradient = [flameStart, flameEnd];
  static const List<Color> playerGradient = [Color(0xFF2196F3), Color(0xFF00BCD4)];

  // 반투명 색상
  static Color blackTransparent(double opacity) => Colors.black.withValues(alpha: opacity);
  static Color whiteTransparent(double opacity) => Colors.white.withValues(alpha: opacity);
}
