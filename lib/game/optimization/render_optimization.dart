import 'package:flame/game.dart';

/// 렌더링 최적화 유틸리티 클래스
class RenderOptimization {
  /// 화면 밖 컴포넌트 렌더링 스킵
  static bool shouldRender(Component component, Camera camera) {
    // 컴포넌트의 바운드 박스
    final bounds = component.toRect();

    // 카메라 뷰포트
    final viewport = camera.view;

    // 교차 판정 (AABB collision)
    return bounds.overlaps(viewport);
  }

  /// 동적 LOD (Level of Detail)
  /// 거리에 따라 렌더링 품질 조정
  static double getDetailLevel(
    double distance,
    double maxDistance,
  ) {
    if (distance > maxDistance) return 0.0; // 렌더링 안 함
    if (distance > maxDistance * 0.8) return 0.5; // 저품질
    return 1.0; // 고품질
  }

  /// 프레임 스킵 최적화
  /// 매 프레임이 아닌 N프레임마다 업데이트
  static bool shouldUpdateEveryNFrames(int frameCount, int interval) {
    return frameCount % interval == 0;
  }

  /// 오브젝트 풀링 (재사용 효율)
  /// - 자주 생성/삭제되는 오브젝트는 풀 사용
  /// - 예: 폭발, 파티클, 적
}

/// 확장: 화면 밖 자동 정리 컴포넌트
mixin AutoCleanupOffscreen on Component {
  @override
  void update(double dt) {
    super.update(dt);

    // 카메라 뷰포트를 벗어나면 제거 (추가 마진)
    final game = parent as FlameGame?;
    if (game == null) return;

    final bounds = toRect();
    final viewport = game.camera.view.inflate(100);

    if (!bounds.overlaps(viewport)) {
      removeFromParent();
    }
  }
}

/// 확장: 조건부 업데이트 (불필요할 때 업데이트 스킵)
mixin ConditionalUpdate on Component {
  late bool _shouldUpdate = true;

  void setShouldUpdate(bool value) {
    _shouldUpdate = value;
  }

  @override
  void update(double dt) {
    if (!_shouldUpdate) return;
    super.update(dt);
  }
}
