class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();

  late String _currentLanguage;
  late Map<String, Map<String, String>> _translations;

  LocalizationManager._internal() {
    _currentLanguage = 'ko';
    _translations = _initializeTranslations();
  }

  factory LocalizationManager() {
    return _instance;
  }

  // 초기화
  void initialize(String language) {
    _currentLanguage = language;
  }

  // 언어 변경
  void setLanguage(String language) {
    if (_translations.containsKey(language)) {
      _currentLanguage = language;
    }
  }

  // 현재 언어
  String get currentLanguage => _currentLanguage;

  // 문자열 가져오기
  String get(String key, [Map<String, String>? params]) {
    String text = _translations[_currentLanguage]?[key] ?? key;

    // 매개변수 치환
    if (params != null) {
      params.forEach((key, value) {
        text = text.replaceAll('{$key}', value);
      });
    }

    return text;
  }

  // 번역 맵 초기화
  Map<String, Map<String, String>> _initializeTranslations() {
    return {
      'ko': {
        // 메인 화면
        'main_title': '신시 봄버맨',
        'main_subtitle': '신시의 요괴를 무찌르세요!',
        'btn_start_game': '게임 시작',
        'btn_select_character': '캐릭터 선택',
        'btn_settings': '설정',
        'btn_high_score': '최고 기록: {score}점',

        // 스테이지 선택
        'stage_select_title': '스테이지 선택',
        'world_1': '인간계',
        'world_2': '요괴계',
        'world_3': '용계',
        'world_4': '신계',
        'world_1_desc': '초급: 도깨비와 기초 전투',
        'world_2_desc': '중급: 요괴들과의 대결',
        'world_3_desc': '상급: 용의 영역',
        'world_4_desc': '최상급: 신계의 최강자',
        'stage_locked': '미해금',
        'stage_label': 'STAGE',

        // 캐릭터 선택
        'character_select_title': '캐릭터 선택',
        'character_locked': '잠금해제',
        'character_unlock_watch_ad': '광고 해금',
        'character_unlock_purchase': '₩1,200',
        'character_unlock_stage': '{stage}스테이지 클리어',
        'btn_select': '선택',
        'character_info': '속도: {speed}, 폭탄: {bomb}, 범위: {range}',

        // 캐릭터 10종
        'char_1': '웅녀의 전사',
        'char_2': '바리데기',
        'char_3': '주몽',
        'char_4': '선덕여왕',
        'char_5': '을지문덕',
        'char_6': '연오랑',
        'char_7': '온달 장군',
        'char_8': '광개토대왕',
        'char_9': '환웅',
        'char_10': '단군왕검',

        // 캐릭터 설명
        'char_desc_1': '기본 능력',
        'char_desc_2': '부활: 화염에 닿아도 1회 복구',
        'char_desc_3': '신궁: 폭탄 범위 2배 증가',
        'char_desc_4': '통찰: 적 위치 미리 감지',
        'char_desc_5': '속전속결: 폭탄 폭발 시간 50% 감소',
        'char_desc_6': '광속: 이동 속도 30% 증가',
        'char_desc_7': '대지강타: 범위 50% 증가, 속도 감소',
        'char_desc_8': '정복: 많은 폭탄 설치 가능',
        'char_desc_9': '뇌신: 최대 범위, 높은 폭탄 수',
        'char_desc_10': '홍익인간: 최고의 모든 능력',

        // 게임 화면 HUD
        'hud_stage': 'STAGE',
        'hud_items': '보유 아이템',
        'hud_item_fireup': '범위',
        'hud_item_bombup': '폭탄',
        'hud_item_speedup': '속도',
        'hud_item_timeextend': '시간',
        'hud_item_shield': '방패',
        'hud_item_curse': '저주',

        // 게임 중
        'game_time_warning': '시간 부족!',
        'enemy_appeared': '{name} 등장!',
        'item_got': '{item} 획득!',

        // 보스 등장 메시지
        'boss_1': '도깨비 대장',
        'boss_2': '구미호 여왕',
        'boss_3': '이무기 대왕',
        'boss_4': '치우천왕',

        // 클리어 화면
        'clear_title': '스테이지 클리어!',
        'clear_perfect': '완벽한 클리어!',
        'clear_score': '점수: {score}점',
        'clear_enemies': '처치한 적: {count}마리',
        'clear_stars': '별점: {stars}/3',
        'btn_next_stage': '다음 스테이지',
        'btn_retry': '다시 도전',

        // 게임오버 화면
        'gameover_title': '게임 오버',
        'gameover_score': '최종 점수: {score}점',
        'gameover_stage': '도달한 스테이지: {stage}',
        'btn_restart': '다시 시작',
        'btn_menu': '메뉴로',

        // 설정
        'settings_title': '설정',
        'settings_language': '언어',
        'settings_sound': '효과음',
        'settings_music': '배경음악',
        'settings_vibration': '진동',
        'settings_on': '켜짐',
        'settings_off': '꺼짐',
        'btn_reset_game': '게임 초기화',
        'btn_about': '정보',

        // 공통
        'ok': '확인',
        'cancel': '취소',
        'yes': '예',
        'no': '아니오',
      },
      'en': {
        // Main Screen
        'main_title': 'Sinsi Bomber',
        'main_subtitle': 'Defeat the monsters of Sinsi!',
        'btn_start_game': 'Start Game',
        'btn_select_character': 'Select Character',
        'btn_settings': 'Settings',
        'btn_high_score': 'High Score: {score}',

        // Stage Selection
        'stage_select_title': 'Stage Select',
        'world_1': 'Humanity Realm',
        'world_2': 'Monster Realm',
        'world_3': 'Dragon Realm',
        'world_4': 'Divine Realm',
        'world_1_desc': 'Beginner: Basic Combat',
        'world_2_desc': 'Intermediate: Monster Battle',
        'world_3_desc': 'Advanced: Dragon Territory',
        'world_4_desc': 'Expert: Divine Realm',
        'stage_locked': 'Locked',
        'stage_label': 'STAGE',

        // Character Selection
        'character_select_title': 'Select Character',
        'character_locked': 'Locked',
        'character_unlock_watch_ad': 'Watch Ad',
        'character_unlock_purchase': '\$1.20',
        'character_unlock_stage': 'Clear Stage {stage}',
        'btn_select': 'Select',
        'character_info': 'Speed: {speed}, Bombs: {bomb}, Range: {range}',

        // Characters
        'char_1': 'Warrior of Ungnyeo',
        'char_2': 'Bari',
        'char_3': 'Jumong',
        'char_4': 'Queen Sondok',
        'char_5': 'Eulji Mundeok',
        'char_6': 'Yeonorang',
        'char_7': 'General Ondal',
        'char_8': 'King Gwanggaeto',
        'char_9': 'Hwanung',
        'char_10': 'Dangun Wanggeom',

        // Character Descriptions
        'char_desc_1': 'Basic Ability',
        'char_desc_2': 'Resurrection: Recover once from flame',
        'char_desc_3': 'Divine Bow: 2x bomb range',
        'char_desc_4': 'Insight: Detect enemy positions',
        'char_desc_5': 'Swift Attack: 50% faster explosion',
        'char_desc_6': 'Light Speed: 30% faster movement',
        'char_desc_7': 'Earth Strike: 50% more range, slower',
        'char_desc_8': 'Conquest: Deploy many bombs',
        'char_desc_9': 'Thunder God: Max range and bombs',
        'char_desc_10': 'Hongik Ingan: All abilities maxed',

        // Game HUD
        'hud_stage': 'STAGE',
        'hud_items': 'Items Held',
        'hud_item_fireup': 'Range',
        'hud_item_bombup': 'Bomb',
        'hud_item_speedup': 'Speed',
        'hud_item_timeextend': 'Time',
        'hud_item_shield': 'Shield',
        'hud_item_curse': 'Curse',

        // In-Game
        'game_time_warning': 'Time Running Out!',
        'enemy_appeared': '{name} Appeared!',
        'item_got': '{item} Obtained!',

        // Boss Names
        'boss_1': 'Dokkaebi Commander',
        'boss_2': 'Nine-Tailed Fox Queen',
        'boss_3': 'Great Imugis',
        'boss_4': 'Chiyou Heavenly King',

        // Clear Screen
        'clear_title': 'Stage Clear!',
        'clear_perfect': 'Perfect Clear!',
        'clear_score': 'Score: {score}',
        'clear_enemies': 'Enemies Defeated: {count}',
        'clear_stars': 'Stars: {stars}/3',
        'btn_next_stage': 'Next Stage',
        'btn_retry': 'Retry',

        // Game Over Screen
        'gameover_title': 'Game Over',
        'gameover_score': 'Final Score: {score}',
        'gameover_stage': 'Reached Stage: {stage}',
        'btn_restart': 'Restart',
        'btn_menu': 'Menu',

        // Settings
        'settings_title': 'Settings',
        'settings_language': 'Language',
        'settings_sound': 'Sound Effects',
        'settings_music': 'Background Music',
        'settings_vibration': 'Vibration',
        'settings_on': 'On',
        'settings_off': 'Off',
        'btn_reset_game': 'Reset Game',
        'btn_about': 'About',

        // Common
        'ok': 'OK',
        'cancel': 'Cancel',
        'yes': 'Yes',
        'no': 'No',
      },
    };
  }
}

// 글로벌 함수로 사용하기 쉽도록
String tr(String key, [Map<String, String>? params]) {
  return LocalizationManager().get(key, params);
}
