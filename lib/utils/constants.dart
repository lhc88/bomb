import 'package:flutter/material.dart';

/// 게임 상수 - 봄버맨
class GameConstants {
  // ===== 앱 정보 =====
  static const String appName = '신시 봄버맨';
  static const String packageName = 'com.sinsi.bomberman';
  static const String version = '1.0.0';

  // ===== 게임판 설정 (Grid) =====
  /// 격자 너비 (가로)
  static const int gridWidth = 15;

  /// 격자 높이 (세로)
  static const int gridHeight = 13;

  /// 한 칸의 크기 (픽셀)
  static const double tileSize = 40.0;

  /// 게임판 전체 너비
  static const double mapWidth = gridWidth * tileSize; // 600px

  /// 게임판 전체 높이
  static const double mapHeight = gridHeight * tileSize; // 520px

  // ===== 플레이어 설정 =====
  /// 기본 이동 속도 (픽셀/초)
  static const double defaultPlayerSpeed = 120.0;

  /// 기본 폭탄 개수
  static const int defaultBombCount = 1;

  /// 기본 폭발 범위 (타일 단위)
  static const int defaultFireRange = 2;

  // ===== 폭탄 및 폭발 설정 =====
  /// 폭탄 폭발 대기 시간 (초)
  static const double bombExplosionDelay = 3.0;

  /// 폭발 효과 지속 시간 (초)
  static const double explosionDuration = 0.5;

  /// 폭탄 깜빡임 간격 (초)
  static const double bombBlinkInterval = 0.2;

  // ===== 스테이지 설정 =====
  /// 총 스테이지 수
  static const int totalStages = 40;

  /// 지역당 스테이지 수
  static const int stagesPerRegion = 10;

  /// 총 지역 수
  static const int totalRegions = 4;

  /// 스테이지 기본 제한 시간 (초)
  static const int stageTimeLimit = 120;

  // ===== 캐릭터 설정 =====
  /// 총 캐릭터 수
  static const int totalCharacters = 10;

  /// 기본 활성 캐릭터 (처음 사용 가능)
  static const int defaultActiveCharacters = 2;

  // ===== 요괴 설정 =====
  /// 요괴 종류 수
  static const int totalEnemyTypes = 4;

  /// 스테이지당 최소 요괴 수
  static const int minEnemiesPerStage = 3;

  /// 스테이지당 최대 요괴 수
  static const int maxEnemiesPerStage = 10;

  // ===== 게임 플레이 설정 =====
  /// 적 처치 시 획득 점수
  static const int scorePerEnemy = 100;

  /// 스테이지 클리어 기본 보너스 점수
  static const int baseStageScore = 1000;

  /// 시간 보너스 점수 (1초당)
  static const int timeBonus = 10;

  // ===== 파워업 설정 =====
  /// 속도 증가 파워업 확률
  static const double speedUpProbability = 0.10; // 10%

  /// 폭탄 증가 파워업 확률
  static const double bombUpProbability = 0.10; // 10%

  /// 범위 증가 파워업 확률
  static const double fireUpProbability = 0.10; // 10%

  /// 속도 증가량 (픽셀/초)
  static const double speedBoost = 40.0;

  /// 폭탄 증가량
  static const int bombCountBoost = 1;

  /// 범위 증가량 (타일)
  static const int fireRangeBoost = 1;

  // ===== 색상 팔레트 =====
  /// 주요 색 - 진홍색
  static const String primaryColorHex = '#8B0000';
  static const Color primaryColor = Color(0xFF8B0000);

  /// 강조 색 - 금색
  static const String accentColorHex = '#B8860B';
  static const Color accentColor = Color(0xFFB8860B);

  /// 배경 색 - 진갈색
  static const String backgroundColorHex = '#2C1810';
  static const Color backgroundColor = Color(0xFF2C1810);

  /// UI 배경 색
  static const String uiBackgroundHex = '#1a1a1a';
  static const Color uiBackground = Color(0xFF1a1a1a);

  /// UI 카드 색
  static const String cardColorHex = '#2d2d2d';
  static const Color cardColor = Color(0xFF2d2d2d);

  /// 텍스트 색
  static const Color textColor = Color(0xFFFFFFFF);

  /// 폭발 색
  static const Color explosionColor = Color(0xFFFF6B35);

  /// 성공 색
  static const Color successColor = Color(0xFF4CAF50);

  /// 실패 색
  static const Color failureColor = Color(0xFFF44336);

  // ===== 게임 요소별 설정 =====
  /// 타일 타입별 파괴 가능 여부
  static const Map<String, bool> tileDestructible = {
    'wall': false, // 벽
    'brick': true, // 벽돌
    'grass': false, // 풀
  };

  /// 요괴 기본 이동 속도 배수
  static const Map<int, double> enemySpeedMultiplier = {
    1: 0.8, // 도깨비
    2: 1.2, // 귀신
    3: 1.0, // 구미호
    4: 0.6, // 이무기
  };

  /// 요괴 기본 HP
  static const Map<int, int> enemyHpMap = {
    1: 1, // 도깨비
    2: 1, // 귀신
    3: 2, // 구미호
    4: 3, // 이무기
  };
}

// ===== 게임 상태 Enum =====
enum GameState {
  menu, // 메뉴
  playing, // 게임 중
  paused, // 일시정지
  stageClear, // 스테이지 클리어
  gameOver, // 게임 오버
}

// ===== 스테이지 지역 Enum =====
enum Region {
  humanWorld, // 인간계
  monsterWorld, // 요괴계
  dragonWorld, // 용계
  divineWorld, // 신계
}

// ===== 지역 정보 클래스 =====
class RegionInfo {
  final Region region;
  final String name;
  final String koreanName;
  final String backgroundAsset;
  final Color accentColor;

  RegionInfo({
    required this.region,
    required this.name,
    required this.koreanName,
    required this.backgroundAsset,
    required this.accentColor,
  });
}

/// 지역별 정보
final List<RegionInfo> regions = [
  RegionInfo(
    region: Region.humanWorld,
    name: 'Human World',
    koreanName: '인간계',
    backgroundAsset: 'assets/images/bg_region1.png',
    accentColor: const Color(0xFF4CAF50),
  ),
  RegionInfo(
    region: Region.monsterWorld,
    name: 'Monster World',
    koreanName: '요괴계',
    backgroundAsset: 'assets/images/bg_region2.png',
    accentColor: const Color(0xFFFF6B35),
  ),
  RegionInfo(
    region: Region.dragonWorld,
    name: 'Dragon World',
    koreanName: '용계',
    backgroundAsset: 'assets/images/bg_region3.png',
    accentColor: const Color(0xFF2196F3),
  ),
  RegionInfo(
    region: Region.divineWorld,
    name: 'Divine World',
    koreanName: '신계',
    backgroundAsset: 'assets/images/bg_region4.png',
    accentColor: const Color(0xFFFFD700),
  ),
];

// ===== 사운드 에셋 클래스 =====
class SoundAssets {
  // 배경음악
  static const String bgmMenu = 'assets/sounds/bgm_menu.mp3';
  static const String bgmGame = 'assets/sounds/bgm_game.mp3';
  static const String bgmBoss = 'assets/sounds/bgm_boss.mp3';

  // 효과음
  static const String sfxBombPlace = 'assets/sounds/sfx_bomb_place.wav';
  static const String sfxExplosion = 'assets/sounds/sfx_explosion.wav';
  static const String sfxEnemyDeath = 'assets/sounds/sfx_enemy_death.wav';
  static const String sfxPlayerDeath = 'assets/sounds/sfx_player_death.wav';
  static const String sfxPowerUp = 'assets/sounds/sfx_power_up.wav';
  static const String sfxStageClear = 'assets/sounds/sfx_stage_clear.wav';
  static const String sfxGameOver = 'assets/sounds/sfx_game_over.wav';
  static const String sfxButtonClick = 'assets/sounds/sfx_button_click.wav';
  static const String sfxCountdown = 'assets/sounds/sfx_countdown.wav';
}

// ===== 이미지 에셋 클래스 =====
class ImageAssets {
  // 배경
  static const String bgRegion1 = 'assets/images/bg_region1.png';
  static const String bgRegion2 = 'assets/images/bg_region2.png';
  static const String bgRegion3 = 'assets/images/bg_region3.png';
  static const String bgRegion4 = 'assets/images/bg_region4.png';

  // 캐릭터 (10명)
  static const String charDangun = 'assets/images/char_dangun.png';
  static const String charHwanung = 'assets/images/char_hwanung.png';
  static const String charJumong = 'assets/images/char_jumong.png';
  static const String charBari = 'assets/images/char_bari.png';
  static const String charYuri = 'assets/images/char_yuri.png';
  static const String charSondok = 'assets/images/char_sondok.png';
  static const String charUlji = 'assets/images/char_ulji.png';
  static const String charOndal = 'assets/images/char_ondal.png';
  static const String charYeongoh = 'assets/images/char_yeongoh.png';
  static const String charGwanggaeto = 'assets/images/char_gwanggaeto.png';

  // 요괴 (4종)
  static const String enemyGoblin = 'assets/images/enemy_goblin.png';
  static const String enemyGhost = 'assets/images/enemy_ghost.png';
  static const String enemyGumiho = 'assets/images/enemy_gumiho.png';
  static const String enemyImugi = 'assets/images/enemy_imugi.png';

  // 게임 요소
  static const String tileBrick = 'assets/images/tile_brick.png';
  static const String tileWall = 'assets/images/tile_wall.png';
  static const String bomb = 'assets/images/bomb.png';
  static const String explosion = 'assets/images/explosion.png';

  // 파워업 아이콘
  static const String iconSpeed = 'assets/images/icon_speed.png';
  static const String iconBomb = 'assets/images/icon_bomb.png';
  static const String iconFire = 'assets/images/icon_fire.png';

  // UI 아이콘
  static const String iconPlay = 'assets/images/icon_play.png';
  static const String iconPause = 'assets/images/icon_pause.png';
  static const String iconSound = 'assets/images/icon_sound.png';
  static const String iconMute = 'assets/images/icon_mute.png';
}
