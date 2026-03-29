import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// 이미지 캐싱 매니저
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();

  late Map<String, Image> _imageCache;
  late Map<String, bool> _imageLoadingStatus;

  CacheManager._internal() {
    _imageCache = {};
    _imageLoadingStatus = {};
  }

  factory CacheManager() {
    return _instance;
  }

  /// 초기화 (앱 시작 시)
  Future<void> initialize() async {
    // 자주 사용되는 이미지 사전 로드
    await preloadCommonImages();
  }

  /// 자주 사용되는 이미지 사전 로드
  Future<void> preloadCommonImages() async {
    final imagePaths = [
      // 게임 보드 타일
      'assets/images/tile_empty.png',
      'assets/images/tile_hardwall.png',
      'assets/images/tile_softwall.png',

      // UI 요소 (사용하면 로드)
      'assets/images/ui_button.png',
      'assets/images/ui_background.png',
    ];

    for (final path in imagePaths) {
      try {
        await loadImage(path);
      } catch (e) {
        print('이미지 사전 로드 실패: $path - $e');
      }
    }
  }

  /// 이미지 로드 (캐시 확인)
  Future<Image> loadImage(String path) async {
    // 캐시에 있으면 반환
    if (_imageCache.containsKey(path)) {
      return _imageCache[path]!;
    }

    // 로딩 중이면 대기
    if (_imageLoadingStatus[path] == true) {
      // 로딩 완료까지 대기
      while (_imageLoadingStatus[path] == true) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      return _imageCache[path]!;
    }

    // 로딩 시작
    _imageLoadingStatus[path] = true;
    try {
      final image = await Flame.images.load(path);
      _imageCache[path] = image;
      _imageLoadingStatus[path] = false;
      return image;
    } catch (e) {
      _imageLoadingStatus[path] = false;
      rethrow;
    }
  }

  /// 캐시된 이미지 직접 접근
  Image? getImage(String path) {
    return _imageCache[path];
  }

  /// 특정 이미지 캐시 제거
  void clearImage(String path) {
    _imageCache.remove(path);
  }

  /// 모든 캐시 제거
  void clearAll() {
    _imageCache.clear();
    _imageLoadingStatus.clear();
  }

  /// 캐시 통계
  Map<String, dynamic> getStats() {
    return {
      'cachedImages': _imageCache.length,
      'totalSize': _imageCache.values
          .fold<int>(0, (sum, img) => sum + (img.width * img.height * 4)),
      'paths': _imageCache.keys.toList(),
    };
  }

  /// 디버그 정보 출력
  void printDebugInfo() {
    final stats = getStats();
    print('=== CacheManager Debug Info ===');
    print('Cached Images: ${stats['cachedImages']}');
    print('Estimated Size: ${(stats['totalSize'] as int) / 1024 / 1024} MB');
    print('Paths: ${stats['paths']}');
  }
}
