enum EnemyType {
  goblin, // 도깨비
  ghost, // 귀신
  gumiho, // 구미호
  imugi, // 이무기
}

class EnemyData {
  final int id;
  final String name;
  final String koreanName;
  final EnemyType type;
  final String imageAsset;
  final double speed; // 픽셀/초
  final int hp;
  final int score; // 처치 시 점수
  final bool canPassThrough; // 벽돌을 지나갈 수 있는가

  EnemyData({
    required this.id,
    required this.name,
    required this.koreanName,
    required this.type,
    required this.imageAsset,
    required this.speed,
    required this.hp,
    required this.score,
    this.canPassThrough = false,
  });

  @override
  String toString() {
    return '$koreanName (HP: $hp, Speed: $speed, Score: $score)';
  }
}

// 요괴 데이터
class Enemies {
  static final List<EnemyData> all = [
    // 1: 도깨비 졸개 - 랜덤 이동
    EnemyData(
      id: 1,
      name: 'Goblin Minion',
      koreanName: '도깨비 졸개',
      type: EnemyType.goblin,
      imageAsset: 'assets/monsters/goblin.png',
      speed: 80.0,
      hp: 1,
      score: 100,
    ),
    // 2: 도깨비 전사 - 플레이어 추적, 빠른 속도
    EnemyData(
      id: 2,
      name: 'Goblin Warrior',
      koreanName: '도깨비 전사',
      type: EnemyType.goblin,
      imageAsset: 'assets/monsters/goblin.png',
      speed: 130.0,
      hp: 1,
      score: 150,
    ),
    // 3: 구미호 - 플레이어 추적, 폭탄 회피 50%
    EnemyData(
      id: 3,
      name: 'Gumiho',
      koreanName: '구미호',
      type: EnemyType.gumiho,
      imageAsset: 'assets/monsters/gumiho.png',
      speed: 110.0,
      hp: 2,
      score: 200,
    ),
    // 4: 이무기 새끼 - 직선 이동, 빠른 속도
    EnemyData(
      id: 4,
      name: 'Young Imugi',
      koreanName: '이무기 새끼',
      type: EnemyType.imugi,
      imageAsset: 'assets/monsters/imugi.png',
      speed: 140.0,
      hp: 1,
      score: 180,
    ),
    // 5: 천마 - 고속 추적, 매우 빠른 이동
    EnemyData(
      id: 5,
      name: 'Cheonma',
      koreanName: '천마',
      type: EnemyType.imugi,
      imageAsset: 'assets/monsters/imugi.png',
      speed: 160.0,
      hp: 1,
      score: 250,
    ),
  ];

  static EnemyData getEnemy(int id) {
    return all.firstWhere((e) => e.id == id, orElse: () => all[0]);
  }

  static EnemyData getRandomEnemy() {
    return all[(DateTime.now().millisecondsSinceEpoch % all.length).toInt()];
  }
}

// 스테이지별 요괴 구성
class StageEnemyComposition {
  final int stageNumber;
  final List<int> enemyIds; // 요괴 ID 리스트
  final int enemyCount;
  final bool hasBoss;
  final int? bossId;

  StageEnemyComposition({
    required this.stageNumber,
    required this.enemyIds,
    required this.enemyCount,
    this.hasBoss = false,
    this.bossId,
  });
}

// 스테이지 요괴 데이터
class StageEnemies {
  static Map<int, StageEnemyComposition> stageCompositions = {
    1: StageEnemyComposition(stageNumber: 1, enemyIds: [1], enemyCount: 3),
    2: StageEnemyComposition(stageNumber: 2, enemyIds: [1, 2], enemyCount: 4),
    3: StageEnemyComposition(stageNumber: 3, enemyIds: [1, 2], enemyCount: 5),
    5: StageEnemyComposition(stageNumber: 5, enemyIds: [2, 3], enemyCount: 5),
    10: StageEnemyComposition(
      stageNumber: 10,
      enemyIds: [1, 2, 3],
      enemyCount: 6,
      hasBoss: true,
      bossId: 3,
    ),
    20: StageEnemyComposition(
      stageNumber: 20,
      enemyIds: [2, 3, 4],
      enemyCount: 8,
      hasBoss: true,
      bossId: 3,
    ),
    30: StageEnemyComposition(
      stageNumber: 30,
      enemyIds: [3, 4],
      enemyCount: 8,
      hasBoss: true,
      bossId: 4,
    ),
    40: StageEnemyComposition(
      stageNumber: 40,
      enemyIds: [3, 4],
      enemyCount: 10,
      hasBoss: true,
      bossId: 4,
    ),
  };

  static StageEnemyComposition? getStageComposition(int stageNumber) {
    return stageCompositions[stageNumber];
  }
}
