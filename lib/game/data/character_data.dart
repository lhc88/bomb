/// 캐릭터 데이터 클래스
class CharacterData {
  /// 캐릭터 고유 ID (1~10)
  final int id;

  /// 한국어 이름
  final String koreanName;

  /// 영문 이름
  final String nameEn;

  /// 폭발 범위 (타일 단위)
  final int bombRange;

  /// 동시 설치 가능한 폭탄 수
  final int bombCount;

  /// 이동 속도 (픽셀/초)
  final double speed;

  /// 폭탄 폭발 지연 시간 (초)
  final double fuseTime;

  /// 패시브 스킬 설명
  final String passiveSkill;

  /// 해금 조건 설명
  final String unlockCondition;

  /// 해금 조건 타입 (none, watchAd, purchase, stageClear)
  final String unlockType;

  /// 해금에 필요한 추가 정보 (가격, 스테이지 등)
  final dynamic unlockValue;

  /// 캐릭터 이미지 에셋
  final String imageAsset;

  /// 해금 여부 (동적 - SaveManager에서 관리)
  bool isUnlocked;

  CharacterData({
    required this.id,
    required this.koreanName,
    required this.nameEn,
    required this.bombRange,
    required this.bombCount,
    required this.speed,
    required this.fuseTime,
    required this.passiveSkill,
    required this.unlockCondition,
    required this.unlockType,
    this.unlockValue,
    required this.imageAsset,
    this.isUnlocked = false,
  });

  /// 과거 호환성을 위한 getter
  int get fireRange => bombRange;
  int get maxBombs => bombCount;
  String get name => koreanName;

  @override
  String toString() {
    return '$koreanName (범위:$bombRange, 폭탄:$bombCount, 속도:$speed, 지연:${fuseTime}s)';
  }
}

/// 캐릭터 관리 클래스
class Characters {
  static final List<CharacterData> all = [
    // 1번: 웅녀의 전사 - 기본 캐릭터
    CharacterData(
      id: 1,
      koreanName: '웅녀의 전사',
      nameEn: 'Warrior of Ungnyeo',
      bombRange: 2,
      bombCount: 1,
      speed: 120.0,
      fuseTime: 3.0,
      passiveSkill: '기본 능력',
      unlockCondition: '처음부터 해금',
      unlockType: 'none',
      imageAsset: 'assets/images/char_dangun.png',
      isUnlocked: true,
    ),

    // 2번: 바리데기 - 광고 해금
    CharacterData(
      id: 2,
      koreanName: '바리데기',
      nameEn: 'Bari',
      bombRange: 2,
      bombCount: 2,
      speed: 140.0,
      fuseTime: 3.0,
      passiveSkill: '부활: 화염에 닿아도 1회 복구',
      unlockCondition: '광고 시청으로 해금',
      unlockType: 'watchAd',
      imageAsset: 'assets/images/char_bari.png',
      isUnlocked: false,
    ),

    // 3번: 주몽 - 광고 해금
    CharacterData(
      id: 3,
      koreanName: '주몽',
      nameEn: 'Jumong',
      bombRange: 4,
      bombCount: 1,
      speed: 140.0,
      fuseTime: 3.0,
      passiveSkill: '신궁: 폭탄 범위 2배 증가',
      unlockCondition: '광고 시청으로 해금',
      unlockType: 'watchAd',
      imageAsset: 'assets/images/char_jumong.png',
      isUnlocked: false,
    ),

    // 4번: 선덕여왕 - 광고 해금
    CharacterData(
      id: 4,
      koreanName: '선덕여왕',
      nameEn: 'Queen Sondok',
      bombRange: 3,
      bombCount: 3,
      speed: 120.0,
      fuseTime: 2.5,
      passiveSkill: '통찰: 적 위치 미리 감지',
      unlockCondition: '광고 시청으로 해금',
      unlockType: 'watchAd',
      imageAsset: 'assets/images/char_sondok.png',
      isUnlocked: false,
    ),

    // 5번: 을지문덕 - 광고 해금
    CharacterData(
      id: 5,
      koreanName: '을지문덕',
      nameEn: 'Eulji Mundeok',
      bombRange: 3,
      bombCount: 2,
      speed: 120.0,
      fuseTime: 1.5,
      passiveSkill: '속전속결: 폭탄 폭발 시간 50% 감소',
      unlockCondition: '광고 시청으로 해금',
      unlockType: 'watchAd',
      imageAsset: 'assets/images/char_ulji.png',
      isUnlocked: false,
    ),

    // 6번: 연오랑 - 인앱 결제 (1,200원)
    CharacterData(
      id: 6,
      koreanName: '연오랑',
      nameEn: 'Yeonorang',
      bombRange: 3,
      bombCount: 2,
      speed: 160.0,
      fuseTime: 3.0,
      passiveSkill: '광속: 이동 속도 30% 증가',
      unlockCondition: '₩1,200으로 구매',
      unlockType: 'purchase',
      unlockValue: 1200,
      imageAsset: 'assets/images/char_yeongoh.png',
      isUnlocked: false,
    ),

    // 7번: 온달 장군 - 인앱 결제 (1,200원)
    CharacterData(
      id: 7,
      koreanName: '온달 장군',
      nameEn: 'General Ondal',
      bombRange: 5,
      bombCount: 1,
      speed: 80.0,
      fuseTime: 3.0,
      passiveSkill: '대지강타: 범위 50% 증가, 속도 감소',
      unlockCondition: '₩1,200으로 구매',
      unlockType: 'purchase',
      unlockValue: 1200,
      imageAsset: 'assets/images/char_ondal.png',
      isUnlocked: false,
    ),

    // 8번: 광개토대왕 - 인앱 결제 (1,200원)
    CharacterData(
      id: 8,
      koreanName: '광개토대왕',
      nameEn: 'King Gwanggaeto',
      bombRange: 4,
      bombCount: 4,
      speed: 140.0,
      fuseTime: 2.0,
      passiveSkill: '정복: 많은 폭탄 설치 가능',
      unlockCondition: '₩1,200으로 구매',
      unlockType: 'purchase',
      unlockValue: 1200,
      imageAsset: 'assets/images/char_gwanggaeto.png',
      isUnlocked: false,
    ),

    // 9번: 환웅 - 인앱 결제 (1,200원)
    CharacterData(
      id: 9,
      koreanName: '환웅',
      nameEn: 'Hwanung',
      bombRange: 6,
      bombCount: 3,
      speed: 140.0,
      fuseTime: 2.0,
      passiveSkill: '뇌신: 최대 범위, 높은 폭탄 수',
      unlockCondition: '₩1,200으로 구매',
      unlockType: 'purchase',
      unlockValue: 1200,
      imageAsset: 'assets/images/char_hwanung.png',
      isUnlocked: false,
    ),

    // 10번: 단군왕검 - 스테이지 40 클리어 (구매 불가)
    CharacterData(
      id: 10,
      koreanName: '단군왕검',
      nameEn: 'Dangun Wanggeom',
      bombRange: 6,
      bombCount: 5,
      speed: 160.0,
      fuseTime: 1.0,
      passiveSkill: '홍익인간: 최고의 모든 능력',
      unlockCondition: '40스테이지 클리어로만 해금 가능',
      unlockType: 'stageClear',
      unlockValue: 40,
      imageAsset: 'assets/images/char_dangun.png',
      isUnlocked: false,
    ),
  ];

  /// ID로 캐릭터 가져오기
  static CharacterData? getCharacter(int id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 기본 캐릭터 반환 (안전장치)
  static CharacterData defaultCharacter() {
    return all[0]; // 웅녀의 전사
  }

  /// 해금된 캐릭터만 필터링
  static List<CharacterData> getUnlockedCharacters() {
    return all.where((c) => c.isUnlocked).toList();
  }

  /// 잠긴 캐릭터만 필터링
  static List<CharacterData> getLockedCharacters() {
    return all.where((c) => !c.isUnlocked).toList();
  }

  /// 광고로 해금 가능한 캐릭터
  static List<CharacterData> getAdUnlockableCharacters() {
    return all.where((c) => c.unlockType == 'watchAd' && !c.isUnlocked).toList();
  }

  /// 구매로 해금 가능한 캐릭터
  static List<CharacterData> getPurchaseUnlockableCharacters() {
    return all.where((c) => c.unlockType == 'purchase' && !c.isUnlocked).toList();
  }

  /// 스테이지 클리어로 해금 가능한 캐릭터
  static List<CharacterData> getStageUnlockableCharacters() {
    return all.where((c) => c.unlockType == 'stageClear' && !c.isUnlocked).toList();
  }

  /// 캐릭터 해금
  static void unlockCharacter(int id) {
    final character = getCharacter(id);
    if (character != null) {
      character.isUnlocked = true;
    }
  }

  /// 모든 캐릭터 해금 (디버그용)
  static void unlockAll() {
    for (var character in all) {
      character.isUnlocked = true;
    }
  }

  /// 정보 출력 (디버그)
  static void printCharacterInfo(int id) {
    final character = getCharacter(id);
    if (character != null) {
      print('=== ${character.koreanName} ===');
      print('범위: ${character.bombRange}, 폭탄: ${character.bombCount}');
      print('속도: ${character.speed}, 지연: ${character.fuseTime}s');
      print('패시브: ${character.passiveSkill}');
      print('해금: ${character.unlockCondition}');
      print('상태: ${character.isUnlocked ? "해금됨" : "잠김"}');
    }
  }
}
