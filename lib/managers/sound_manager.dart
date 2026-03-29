import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'save_manager.dart';

/// 게임 사운드 관리 클래스
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();

  late bool _soundEnabled;
  late bool _musicEnabled;
  late bool _vibrationEnabled;

  // 사운드 앗셋 키
  static const String _bombPlace = 'bomb_place.wav';
  static const String _explosion = 'explosion.wav';
  static const String _wallBreak = 'wall_break.wav';
  static const String _itemGet = 'item_get.wav';
  static const String _playerDeath = 'player_death.wav';
  static const String _enemyDeath = 'enemy_death.wav';
  static const String _stageClear = 'stage_clear.wav';
  static const String _bossAppear = 'boss_appear.wav';
  static const String _bgmLoop = 'bgm_loop.mp3';

  SoundManager._internal();

  factory SoundManager() {
    return _instance;
  }

  /// 초기화 (앱 시작 시 호출)
  Future<void> initialize() async {
    final settings = SaveManager().loadGameSettings();
    _soundEnabled = settings['sound'] ?? true;
    _musicEnabled = settings['music'] ?? true;
    _vibrationEnabled = settings['vibration'] ?? true;

    // Flame Audio 초기화
    await FlameAudio.bgm.initialize();

    // 사운드 사전 로드
    await _preloadSounds();
  }

  /// 효과음 사전 로드
  Future<void> _preloadSounds() async {
    final soundPaths = [
      _bombPlace,
      _explosion,
      _wallBreak,
      _itemGet,
      _playerDeath,
      _enemyDeath,
      _stageClear,
      _bossAppear,
    ];

    for (final path in soundPaths) {
      try {
        await FlameAudio.audioCache.load(path);
      } catch (e) {
        print('사운드 사전 로드 실패: $path - $e');
      }
    }
  }

  // ===== 설정 관리 =====

  /// 효과음 활성화 상태
  bool get soundEnabled => _soundEnabled;

  /// BGM 활성화 상태
  bool get musicEnabled => _musicEnabled;

  /// 진동 활성화 상태
  bool get vibrationEnabled => _vibrationEnabled;

  /// 효과음 토글
  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    await SaveManager().saveGameSettings(
      soundEnabled: _soundEnabled,
      musicEnabled: _musicEnabled,
      vibrationEnabled: _vibrationEnabled,
    );
  }

  /// BGM 토글
  Future<void> toggleMusic() async {
    _musicEnabled = !_musicEnabled;
    if (!_musicEnabled) {
      await stopBGM();
    } else {
      await playBGM();
    }
    await SaveManager().saveGameSettings(
      soundEnabled: _soundEnabled,
      musicEnabled: _musicEnabled,
      vibrationEnabled: _vibrationEnabled,
    );
  }

  /// 진동 토글
  Future<void> toggleVibration() async {
    _vibrationEnabled = !_vibrationEnabled;
    await SaveManager().saveGameSettings(
      soundEnabled: _soundEnabled,
      musicEnabled: _musicEnabled,
      vibrationEnabled: _vibrationEnabled,
    );
  }

  // ===== 효과음 재생 =====

  /// 폭탄 설치음
  Future<void> playBombPlace() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_bombPlace);
    } catch (e) {
      print('폭탄 설치음 재생 실패: $e');
    }
  }

  /// 폭발음
  Future<void> playExplosion() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_explosion);
      await vibrate(intensity: 100);
    } catch (e) {
      print('폭발음 재생 실패: $e');
    }
  }

  /// 벽 파괴음
  Future<void> playWallBreak() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_wallBreak);
    } catch (e) {
      print('벽 파괴음 재생 실패: $e');
    }
  }

  /// 아이템 획득음
  Future<void> playItemGet() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_itemGet);
      await vibrate(intensity: 50);
    } catch (e) {
      print('아이템 획득음 재생 실패: $e');
    }
  }

  /// 플레이어 사망음
  Future<void> playPlayerDeath() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_playerDeath);
      await vibrate(duration: 500, intensity: 150);
    } catch (e) {
      print('플레이어 사망음 재생 실패: $e');
    }
  }

  /// 요괴 처치음
  Future<void> playEnemyDeath() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_enemyDeath);
      await vibrate(intensity: 75);
    } catch (e) {
      print('요괴 처치음 재생 실패: $e');
    }
  }

  /// 스테이지 클리어음
  Future<void> playStageClear() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_stageClear);
      await vibrate(duration: 300, intensity: 100);
    } catch (e) {
      print('스테이지 클리어음 재생 실패: $e');
    }
  }

  /// 보스 등장음
  Future<void> playBossAppear() async {
    if (!_soundEnabled) return;
    try {
      await FlameAudio.play(_bossAppear);
      await vibrate(duration: 400, intensity: 150);
    } catch (e) {
      print('보스 등장음 재생 실패: $e');
    }
  }

  // ===== BGM 관리 =====

  /// BGM 재생 (루프)
  Future<void> playBGM() async {
    if (!_musicEnabled) return;
    try {
      await FlameAudio.bgm.play(_bgmLoop, volume: 0.5);
    } catch (e) {
      print('BGM 재생 실패: $e');
    }
  }

  /// BGM 중지
  Future<void> stopBGM() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (e) {
      print('BGM 중지 실패: $e');
    }
  }

  /// BGM 일시정지
  Future<void> pauseBGM() async {
    try {
      await FlameAudio.bgm.pause();
    } catch (e) {
      print('BGM 일시정지 실패: $e');
    }
  }

  /// BGM 재개
  Future<void> resumeBGM() async {
    if (!_musicEnabled) return;
    try {
      await FlameAudio.bgm.resume();
    } catch (e) {
      print('BGM 재개 실패: $e');
    }
  }

  // ===== 진동 =====

  /// 진동 실행
  Future<void> vibrate({
    int duration = 100,
    int intensity = 100,
  }) async {
    if (!_vibrationEnabled) return;
    try {
      // duration과 intensity를 고려한 진동 패턴
      await HapticFeedback.mediumImpact();
    } catch (e) {
      print('진동 실패: $e');
    }
  }

  /// 경한 진동 (가벼운 터치)
  Future<void> vibrateLight() async {
    if (!_vibrationEnabled) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // 무시
    }
  }

  /// 강한 진동 (충격)
  Future<void> vibrateHeavy() async {
    if (!_vibrationEnabled) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // 무시
    }
  }

  // ===== 모든 사운드 중지 =====

  /// 모든 사운드 중지 (게임 일시정지)
  Future<void> pauseAll() async {
    try {
      await FlameAudio.bgm.pause();
    } catch (e) {
      print('사운드 일시정지 실패: $e');
    }
  }

  /// 모든 사운드 재개 (게임 재개)
  Future<void> resumeAll() async {
    if (_musicEnabled) {
      try {
        await FlameAudio.bgm.resume();
      } catch (e) {
        print('사운드 재개 실패: $e');
      }
    }
  }

  // ===== 디버그 =====

  /// 디버그 정보 출력
  void printDebugInfo() {
    print('=== SoundManager Debug Info ===');
    print('Sound Enabled: $_soundEnabled');
    print('Music Enabled: $_musicEnabled');
    print('Vibration Enabled: $_vibrationEnabled');
  }
}
