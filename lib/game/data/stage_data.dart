/// 스테이지 데이터 클래스
class StageData {
  /// 스테이지 번호 (1~40)
  final int stageNumber;

  /// 스테이지 영문 이름
  final String name;

  /// 스테이지 한글 이름
  final String koreanName;

  /// 월드 이름 (인간계, 요괴계, 용계, 신계)
  final String world;

  /// 난이도 (1~5)
  final int difficulty;

  /// 제한 시간 (초)
  final int timeLimit;

  /// 배경 에셋
  final String backgroundAsset;

  /// 기본 점수
  final int baseScore;

  /// 보스 스테이지 여부
  final bool isBossStage;

  /// 보스 타입 (보스 스테이지만)
  final int? bossType;

  /// 등장 요괴 타입 (ID 목록)
  final List<int> enemyTypes;

  /// 클리어 시 해금 캐릭터 ID
  final int? unlockCharacterId;

  /// 요괴 이동 속도 배수 (기본값 1.0)
  final double enemySpeed;

  /// 부드러운 벽 밀도 (0.0~1.0, 높을수록 어려움)
  final double softWallDensity;

  /// 아이템 등장 확률 (0.0~1.0, 높을수록 많음)
  final double itemDropRate;

  StageData({
    required this.stageNumber,
    required this.name,
    required this.koreanName,
    required this.world,
    required this.difficulty,
    required this.timeLimit,
    required this.backgroundAsset,
    required this.baseScore,
    this.isBossStage = false,
    this.bossType,
    required this.enemyTypes,
    this.unlockCharacterId,
    this.enemySpeed = 1.0,
    this.softWallDensity = 0.3,
    this.itemDropRate = 0.5,
  });

  /// 요괴 수 계산
  int getEnemyCount() {
    if (isBossStage) return 1; // 보스만
    return 2 + (stageNumber ~/ 5); // 스테이지가 높을수록 증가
  }

  /// 난이도 배수
  double getDifficultyMultiplier() {
    return 1.0 + ((stageNumber - 1) * 0.2);
  }

  /// 스테이지 위치 정보 (월드 내 순번)
  int get regionIndex => (stageNumber - 1) ~/ 10;
  int get stageInRegion => (stageNumber - 1) % 10 + 1;

  @override
  String toString() {
    return 'Stage $stageNumber: $koreanName (난이도: $difficulty/5, 시간: ${timeLimit}초)';
  }
}

/// 40개 스테이지 데이터 관리 클래스
class Stages {
  static final List<StageData> all = _generateStages();

  /// 40개 스테이지 생성
  static List<StageData> _generateStages() {
    List<StageData> stages = [];

    // 인간계 (1-10)
    stages.addAll(_generateRegion1());
    // 요괴계 (11-20)
    stages.addAll(_generateRegion2());
    // 용계 (21-30)
    stages.addAll(_generateRegion3());
    // 신계 (31-40)
    stages.addAll(_generateRegion4());

    return stages;
  }

  /// 인간계 (1-10): 도깨비 졸개/전사, 기본 요괴
  static List<StageData> _generateRegion1() => [
    // 1-5: 튜토리얼 (쉬움)
    StageData(
      stageNumber: 1, name: 'Stage 01', koreanName: '인간계 1',
      world: '인간계', difficulty: 1, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 100, enemyTypes: [1],
      enemySpeed: 0.8, softWallDensity: 0.2, itemDropRate: 0.8,
    ),
    StageData(
      stageNumber: 2, name: 'Stage 02', koreanName: '인간계 2',
      world: '인간계', difficulty: 1, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 200, enemyTypes: [1, 1],
      enemySpeed: 0.8, softWallDensity: 0.2, itemDropRate: 0.75,
    ),
    StageData(
      stageNumber: 3, name: 'Stage 03', koreanName: '인간계 3',
      world: '인간계', difficulty: 2, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 300, enemyTypes: [1, 2],
      enemySpeed: 0.85, softWallDensity: 0.2, itemDropRate: 0.7,
    ),
    StageData(
      stageNumber: 4, name: 'Stage 04', koreanName: '인간계 4',
      world: '인간계', difficulty: 2, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 400, enemyTypes: [1, 1, 2],
      enemySpeed: 0.85, softWallDensity: 0.2, itemDropRate: 0.7,
    ),
    StageData(
      stageNumber: 5, name: 'Stage 05', koreanName: '인간계 5',
      world: '인간계', difficulty: 2, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 500, enemyTypes: [2, 2],
      enemySpeed: 0.9, softWallDensity: 0.25, itemDropRate: 0.7,
    ),
    // 6-9: 보통 난이도 진입
    StageData(
      stageNumber: 6, name: 'Stage 06', koreanName: '인간계 6',
      world: '인간계', difficulty: 3, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 600, enemyTypes: [1, 2, 2],
      enemySpeed: 1.0, softWallDensity: 0.3, itemDropRate: 0.5,
    ),
    StageData(
      stageNumber: 7, name: 'Stage 07', koreanName: '인간계 7',
      world: '인간계', difficulty: 3, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 700, enemyTypes: [2, 2, 2],
      enemySpeed: 1.05, softWallDensity: 0.3, itemDropRate: 0.5,
    ),
    StageData(
      stageNumber: 8, name: 'Stage 08', koreanName: '인간계 8',
      world: '인간계', difficulty: 3, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 800, enemyTypes: [2, 2, 2, 1],
      enemySpeed: 1.1, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    StageData(
      stageNumber: 9, name: 'Stage 09', koreanName: '인간계 9',
      world: '인간계', difficulty: 4, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 900, enemyTypes: [2, 2, 2, 2],
      enemySpeed: 1.1, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    // 10: 보스 스테이지
    StageData(
      stageNumber: 10, name: 'Stage 10', koreanName: '인간계 보스',
      world: '인간계', difficulty: 5, timeLimit: 120,
      backgroundAsset: 'assets/backgrounds/region1.png',
      baseScore: 1000, isBossStage: true, bossType: 1, enemyTypes: [],
      enemySpeed: 1.2, softWallDensity: 0.3, itemDropRate: 0.3,
    ),
  ];

  /// 요괴계 (11-20): 구미호 추가, 20은 보스 스테이지
  static List<StageData> _generateRegion2() => [
    // 11-15: 보통 난이도
    StageData(
      stageNumber: 11, name: 'Stage 11', koreanName: '요괴계 1',
      world: '요괴계', difficulty: 2, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1100, enemyTypes: [1, 2, 3],
      enemySpeed: 1.1, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    StageData(
      stageNumber: 12, name: 'Stage 12', koreanName: '요괴계 2',
      world: '요괴계', difficulty: 2, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1200, enemyTypes: [2, 2, 3],
      enemySpeed: 1.1, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    StageData(
      stageNumber: 13, name: 'Stage 13', koreanName: '요괴계 3',
      world: '요괴계', difficulty: 3, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1300, enemyTypes: [2, 3, 3],
      enemySpeed: 1.15, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    StageData(
      stageNumber: 14, name: 'Stage 14', koreanName: '요괴계 4',
      world: '요괴계', difficulty: 3, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1400, enemyTypes: [3, 3, 3],
      enemySpeed: 1.15, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    StageData(
      stageNumber: 15, name: 'Stage 15', koreanName: '요괴계 5',
      world: '요괴계', difficulty: 3, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1500, enemyTypes: [2, 3, 3, 3],
      enemySpeed: 1.2, softWallDensity: 0.35, itemDropRate: 0.4,
    ),
    // 16-19: 중간 난이도
    StageData(
      stageNumber: 16, name: 'Stage 16', koreanName: '요괴계 6',
      world: '요괴계', difficulty: 3, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1600, enemyTypes: [3, 3, 3, 1],
      enemySpeed: 1.2, softWallDensity: 0.4, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 17, name: 'Stage 17', koreanName: '요괴계 7',
      world: '요괴계', difficulty: 4, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1700, enemyTypes: [3, 3, 3, 2],
      enemySpeed: 1.25, softWallDensity: 0.4, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 18, name: 'Stage 18', koreanName: '요괴계 8',
      world: '요괴계', difficulty: 4, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1800, enemyTypes: [2, 3, 3, 3, 3],
      enemySpeed: 1.25, softWallDensity: 0.4, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 19, name: 'Stage 19', koreanName: '요괴계 9',
      world: '요괴계', difficulty: 4, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 1900, enemyTypes: [3, 3, 3, 3, 3],
      enemySpeed: 1.3, softWallDensity: 0.4, itemDropRate: 0.3,
    ),
    // 20: 보스 스테이지
    StageData(
      stageNumber: 20, name: 'Stage 20', koreanName: '요괴계 보스',
      world: '요괴계', difficulty: 5, timeLimit: 100,
      backgroundAsset: 'assets/backgrounds/region2.png',
      baseScore: 2000, isBossStage: true, bossType: 2, enemyTypes: [],
      enemySpeed: 1.4, softWallDensity: 0.4, itemDropRate: 0.25,
    ),
  ];

  /// 용계 (21-30): 이무기 새끼 추가, 30은 보스 스테이지
  static List<StageData> _generateRegion3() => [
    // 21-25: 중간 난이도
    StageData(
      stageNumber: 21, name: 'Stage 21', koreanName: '용계 1',
      world: '용계', difficulty: 3, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2100, enemyTypes: [2, 3, 4],
      enemySpeed: 1.3, softWallDensity: 0.45, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 22, name: 'Stage 22', koreanName: '용계 2',
      world: '용계', difficulty: 3, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2200, enemyTypes: [3, 3, 4],
      enemySpeed: 1.3, softWallDensity: 0.45, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 23, name: 'Stage 23', koreanName: '용계 3',
      world: '용계', difficulty: 3, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2300, enemyTypes: [3, 4, 4],
      enemySpeed: 1.35, softWallDensity: 0.45, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 24, name: 'Stage 24', koreanName: '용계 4',
      world: '용계', difficulty: 4, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2400, enemyTypes: [4, 4, 4],
      enemySpeed: 1.35, softWallDensity: 0.45, itemDropRate: 0.3,
    ),
    StageData(
      stageNumber: 25, name: 'Stage 25', koreanName: '용계 5',
      world: '용계', difficulty: 4, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2500, enemyTypes: [3, 4, 4, 4],
      enemySpeed: 1.4, softWallDensity: 0.45, itemDropRate: 0.3,
    ),
    // 26-29: 어려움
    StageData(
      stageNumber: 26, name: 'Stage 26', koreanName: '용계 6',
      world: '용계', difficulty: 4, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2600, enemyTypes: [4, 4, 4, 2],
      enemySpeed: 1.4, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 27, name: 'Stage 27', koreanName: '용계 7',
      world: '용계', difficulty: 4, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2700, enemyTypes: [4, 4, 4, 3],
      enemySpeed: 1.45, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 28, name: 'Stage 28', koreanName: '용계 8',
      world: '용계', difficulty: 4, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2800, enemyTypes: [3, 4, 4, 4, 4],
      enemySpeed: 1.45, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 29, name: 'Stage 29', koreanName: '용계 9',
      world: '용계', difficulty: 5, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 2900, enemyTypes: [4, 4, 4, 4, 4],
      enemySpeed: 1.5, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    // 30: 보스 스테이지
    StageData(
      stageNumber: 30, name: 'Stage 30', koreanName: '용계 보스',
      world: '용계', difficulty: 5, timeLimit: 90,
      backgroundAsset: 'assets/backgrounds/region3.png',
      baseScore: 3000, isBossStage: true, bossType: 3, enemyTypes: [],
      enemySpeed: 1.5, softWallDensity: 0.5, itemDropRate: 0.15,
    ),
  ];

  /// 신계 (31-40): 천마 추가, 40은 최종 보스, 40 클리어 시 단군왕검 해금
  static List<StageData> _generateRegion4() => [
    // 31-35: 어려움
    StageData(
      stageNumber: 31, name: 'Stage 31', koreanName: '신계 1',
      world: '신계', difficulty: 4, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3100, enemyTypes: [3, 4, 5],
      enemySpeed: 1.4, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 32, name: 'Stage 32', koreanName: '신계 2',
      world: '신계', difficulty: 4, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3200, enemyTypes: [4, 4, 5],
      enemySpeed: 1.4, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 33, name: 'Stage 33', koreanName: '신계 3',
      world: '신계', difficulty: 4, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3300, enemyTypes: [4, 5, 5],
      enemySpeed: 1.45, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 34, name: 'Stage 34', koreanName: '신계 4',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3400, enemyTypes: [5, 5, 5],
      enemySpeed: 1.45, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    StageData(
      stageNumber: 35, name: 'Stage 35', koreanName: '신계 5',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3500, enemyTypes: [4, 5, 5, 5],
      enemySpeed: 1.5, softWallDensity: 0.5, itemDropRate: 0.2,
    ),
    // 36-39: 매우 어려움
    StageData(
      stageNumber: 36, name: 'Stage 36', koreanName: '신계 6',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3600, enemyTypes: [5, 5, 5, 3],
      enemySpeed: 1.5, softWallDensity: 0.55, itemDropRate: 0.15,
    ),
    StageData(
      stageNumber: 37, name: 'Stage 37', koreanName: '신계 7',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3700, enemyTypes: [5, 5, 5, 4],
      enemySpeed: 1.55, softWallDensity: 0.55, itemDropRate: 0.15,
    ),
    StageData(
      stageNumber: 38, name: 'Stage 38', koreanName: '신계 8',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3800, enemyTypes: [4, 5, 5, 5, 5],
      enemySpeed: 1.55, softWallDensity: 0.55, itemDropRate: 0.15,
    ),
    StageData(
      stageNumber: 39, name: 'Stage 39', koreanName: '신계 9',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 3900, enemyTypes: [5, 5, 5, 5, 5],
      enemySpeed: 1.6, softWallDensity: 0.6, itemDropRate: 0.15,
    ),
    // 40: 최종 보스
    StageData(
      stageNumber: 40, name: 'Stage 40', koreanName: '신계 보스',
      world: '신계', difficulty: 5, timeLimit: 80,
      backgroundAsset: 'assets/backgrounds/region4.png',
      baseScore: 4000, isBossStage: true, bossType: 4, enemyTypes: [],
      enemySpeed: 1.6, softWallDensity: 0.6, itemDropRate: 0.1,
      unlockCharacterId: 10, // 단군왕검 해금
    ),
  ];

  /// 스테이지 조회
  static StageData? getStage(int stageNumber) {
    if (stageNumber < 1 || stageNumber > 40) return null;
    return all[stageNumber - 1];
  }

  /// 월드별 스테이지 조회
  static List<StageData> getStagesByWorld(String world) {
    return all.where((s) => s.world == world).toList();
  }

  /// 보스 스테이지 조회
  static List<StageData> getBossStages() {
    return all.where((s) => s.isBossStage).toList();
  }

  /// 총 스테이지 수
  static int getTotalStages() => 40;
}

// 게임 진행 상태
class GameProgress {
  late int currentStage;
  late int maxStageUnlocked;
  late int totalScore;
  late int totalDeaths;
  late int totalEnemiesDefeated;

  GameProgress({
    this.currentStage = 1,
    this.maxStageUnlocked = 1,
    this.totalScore = 0,
    this.totalDeaths = 0,
    this.totalEnemiesDefeated = 0,
  });

  bool isStageUnlocked(int stageNumber) {
    return stageNumber <= maxStageUnlocked;
  }

  void unlockNextStage() {
    maxStageUnlocked++;
  }

  void updateProgress(int score, int enemiesDefeated) {
    totalScore += score;
    totalEnemiesDefeated += enemiesDefeated;
  }

  void recordDeath() {
    totalDeaths++;
  }

  void reset() {
    currentStage = 1;
    totalScore = 0;
    totalDeaths = 0;
    totalEnemiesDefeated = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStage': currentStage,
      'maxStageUnlocked': maxStageUnlocked,
      'totalScore': totalScore,
      'totalDeaths': totalDeaths,
      'totalEnemiesDefeated': totalEnemiesDefeated,
    };
  }

  static GameProgress fromJson(Map<String, dynamic> json) {
    return GameProgress(
      currentStage: json['currentStage'] ?? 1,
      maxStageUnlocked: json['maxStageUnlocked'] ?? 1,
      totalScore: json['totalScore'] ?? 0,
      totalDeaths: json['totalDeaths'] ?? 0,
      totalEnemiesDefeated: json['totalEnemiesDefeated'] ?? 0,
    );
  }
}
