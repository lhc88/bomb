import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 저장 데이터 관리 클래스 (싱글톤)
class SaveManager {
  static final SaveManager _instance = SaveManager._internal();

  late SharedPreferences _prefs;

  // 저장 키 정의
  static const String _keySelectedCharacter = 'bomberman_selected_char';
  static const String _keyUnlockedCharacters = 'bomberman_unlocked_chars';
  static const String _keyStageClear = 'bomberman_stage_clear';
  static const String _keyStageScores = 'bomberman_stage_scores';
  static const String _keyStageStars = 'bomberman_stage_stars';
  static const String _keyGameSettings = 'bomberman_settings';
  static const String _keyAdsFree = 'bomberman_ads_free';
  static const String _keyTotalScore = 'bomberman_total_score';
  static const String _keyTutorialCompleted = 'bomberman_tutorial_completed';

  SaveManager._internal();

  factory SaveManager() {
    return _instance;
  }

  /// 초기화 (앱 시작 시 호출)
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===== 캐릭터 관리 =====

  /// 선택한 캐릭터 저장
  Future<void> saveSelectedCharacter(int characterId) async {
    await _prefs.setInt(_keySelectedCharacter, characterId);
  }

  /// 선택한 캐릭터 로드
  int loadSelectedCharacter() {
    return _prefs.getInt(_keySelectedCharacter) ?? 1; // 기본값: 웅녀의 전사
  }

  /// 해금된 캐릭터 저장
  Future<void> saveUnlockedCharacters(List<int> characterIds) async {
    final json = jsonEncode(characterIds);
    await _prefs.setString(_keyUnlockedCharacters, json);
  }

  /// 해금된 캐릭터 로드
  List<int> loadUnlockedCharacters() {
    final json = _prefs.getString(_keyUnlockedCharacters);
    if (json != null) {
      try {
        final List<dynamic> data = jsonDecode(json);
        return List<int>.from(data);
      } catch (e) {
        print('해금 캐릭터 로드 실패: $e');
        return [1]; // 기본값: 첫 번째 캐릭터만
      }
    }
    return [1];
  }

  /// 캐릭터 해금
  Future<void> unlockCharacter(int characterId) async {
    List<int> unlocked = loadUnlockedCharacters();
    if (!unlocked.contains(characterId)) {
      unlocked.add(characterId);
      unlocked.sort();
      await saveUnlockedCharacters(unlocked);
    }
  }

  // ===== 스테이지 진행 =====

  /// 스테이지 클리어 저장
  Future<void> saveStageCleared(int stageNumber) async {
    Map<String, bool> cleared = loadStageClear();
    cleared[stageNumber.toString()] = true;
    final json = jsonEncode(cleared);
    await _prefs.setString(_keyStageClear, json);
  }

  /// 스테이지 클리어 여부 로드
  Map<String, bool> loadStageClear() {
    final json = _prefs.getString(_keyStageClear);
    if (json != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        return data.map((key, value) => MapEntry(key, value as bool));
      } catch (e) {
        print('스테이지 클리어 로드 실패: $e');
        return {};
      }
    }
    return {};
  }

  /// 스테이지 클리어 여부 확인
  bool isStageClear(int stageNumber) {
    final cleared = loadStageClear();
    return cleared[stageNumber.toString()] ?? false;
  }

  // ===== 스테이지 점수 =====

  /// 스테이지 최고 점수 저장
  Future<void> saveStageScore(int stageNumber, int score) async {
    Map<String, int> scores = loadStageScores();
    final key = stageNumber.toString();

    // 최고 점수만 저장
    if (!scores.containsKey(key) || score > scores[key]!) {
      scores[key] = score;
      final json = jsonEncode(scores);
      await _prefs.setString(_keyStageScores, json);
    }
  }

  /// 스테이지 최고 점수 로드
  Map<String, int> loadStageScores() {
    final json = _prefs.getString(_keyStageScores);
    if (json != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        return data.map((key, value) => MapEntry(key, value as int));
      } catch (e) {
        print('스테이지 점수 로드 실패: $e');
        return {};
      }
    }
    return {};
  }

  /// 특정 스테이지 점수 조회
  int getStageScore(int stageNumber) {
    final scores = loadStageScores();
    return scores[stageNumber.toString()] ?? 0;
  }

  // ===== 스테이지 별점 =====

  /// 스테이지 별점 저장 (1~3)
  Future<void> saveStageStar(int stageNumber, int stars) async {
    Map<String, int> starMap = loadStageStars();
    final key = stageNumber.toString();
    final validStars = stars.clamp(1, 3);

    // 더 높은 별점만 저장
    if (!starMap.containsKey(key) || validStars > starMap[key]!) {
      starMap[key] = validStars;
      final json = jsonEncode(starMap);
      await _prefs.setString(_keyStageStars, json);
    }
  }

  /// 스테이지 별점 로드
  Map<String, int> loadStageStars() {
    final json = _prefs.getString(_keyStageStars);
    if (json != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        return data.map((key, value) => MapEntry(key, value as int));
      } catch (e) {
        print('별점 로드 실패: $e');
        return {};
      }
    }
    return {};
  }

  /// 특정 스테이지 별점 조회
  int getStageStar(int stageNumber) {
    final stars = loadStageStars();
    return stars[stageNumber.toString()] ?? 0;
  }

  // ===== 전체 점수 =====

  /// 전체 최고 점수 저장
  Future<void> saveTotalScore(int score) async {
    final currentHigh = _prefs.getInt(_keyTotalScore) ?? 0;
    if (score > currentHigh) {
      await _prefs.setInt(_keyTotalScore, score);
    }
  }

  /// 전체 최고 점수 로드
  int loadTotalScore() {
    return _prefs.getInt(_keyTotalScore) ?? 0;
  }

  // ===== 게임 설정 =====

  /// 게임 설정 저장
  Future<void> saveGameSettings({
    required bool soundEnabled,
    required bool musicEnabled,
    required bool vibrationEnabled,
  }) async {
    final settings = {
      'sound': soundEnabled,
      'music': musicEnabled,
      'vibration': vibrationEnabled,
    };
    final json = jsonEncode(settings);
    await _prefs.setString(_keyGameSettings, json);
  }

  /// 게임 설정 로드
  Map<String, bool> loadGameSettings() {
    final json = _prefs.getString(_keyGameSettings);
    if (json != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        return {
          'sound': data['sound'] ?? true,
          'music': data['music'] ?? true,
          'vibration': data['vibration'] ?? true,
        };
      } catch (e) {
        print('게임 설정 로드 실패: $e');
        return {'sound': true, 'music': true, 'vibration': true};
      }
    }
    return {'sound': true, 'music': true, 'vibration': true};
  }

  // ===== 광고 제거 =====

  /// 광고 제거 구매 저장
  Future<void> saveAdsFree(bool isFree) async {
    await _prefs.setBool(_keyAdsFree, isFree);
  }

  /// 광고 제거 구매 여부 로드
  bool loadAdsFree() {
    return _prefs.getBool(_keyAdsFree) ?? false;
  }

  // ===== 튜토리얼 =====

  /// 튜토리얼 완료 저장
  Future<void> saveTutorialCompleted(bool completed) async {
    await _prefs.setBool(_keyTutorialCompleted, completed);
  }

  /// 튜토리얼 완료 여부 로드
  bool loadTutorialCompleted() {
    return _prefs.getBool(_keyTutorialCompleted) ?? false;
  }

  // ===== 데이터 초기화 =====

  /// 모든 데이터 초기화
  Future<void> clearAllData() async {
    await _prefs.clear();
  }

  /// 게임 진행 데이터만 초기화 (캐릭터, 설정 유지)
  Future<void> resetGameProgress() async {
    await _prefs.remove(_keyStageClear);
    await _prefs.remove(_keyStageScores);
    await _prefs.remove(_keyStageStars);
    await _prefs.remove(_keyTotalScore);
  }

  /// 디버그: 저장된 모든 데이터 출력
  void printDebugInfo() {
    print('=== SaveManager Debug Info ===');
    print('Selected Character: ${loadSelectedCharacter()}');
    print('Unlocked Characters: ${loadUnlockedCharacters()}');
    print('Cleared Stages: ${loadStageClear()}');
    print('Stage Scores: ${loadStageScores()}');
    print('Stage Stars: ${loadStageStars()}');
    print('Total Score: ${loadTotalScore()}');
    print('Ads Free: ${loadAdsFree()}');
    print('Settings: ${loadGameSettings()}');
  }
}
