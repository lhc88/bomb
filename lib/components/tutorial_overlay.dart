import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 튜토리얼 단계
enum TutorialStep {
  movement,      // 1. 이동 버튼으로 움직여보세요
  bombPlacement, // 2. 폭탄 버튼을 눌러보세요
  escape,        // 3. 폭발 전에 피하세요!
  enemyDefeat,   // 4. 폭발로 요괴를 처치하세요!
  exit,          // 5. 출구로 이동하세요!
}

/// 튜토리얼 오버레이 컴포넌트
class TutorialOverlay extends PositionComponent {
  /// 현재 튜토리얼 단계
  TutorialStep currentStep;

  /// 콜백: 튜토리얼 완료
  final VoidCallback? onTutorialCompleted;

  /// 콜백: 다음 단계로 진행
  final Function(TutorialStep)? onStepChanged;

  /// 단계별 설명 텍스트
  static const Map<TutorialStep, String> stepTexts = {
    TutorialStep.movement: '이동 버튼으로 움직여보세요!\n(탭으로 건너뛸 수 있습니다)',
    TutorialStep.bombPlacement: '폭탄 버튼을 눌러\n폭탄을 설치해보세요!',
    TutorialStep.escape: '폭발 전에 피하세요!\n빠르게 움직여야 합니다!',
    TutorialStep.enemyDefeat: '폭발로 요괴를 처치하세요!\n모든 요괴를 없애야 합니다!',
    TutorialStep.exit: '출구로 이동하여\n스테이지를 클리어하세요!',
  };

  /// 단계별 화살표 위치 (상대 좌표)
  static const Map<TutorialStep, Alignment> arrowAlignments = {
    TutorialStep.movement: Alignment.bottomCenter,
    TutorialStep.bombPlacement: Alignment.bottomRight,
    TutorialStep.escape: Alignment.centerRight,
    TutorialStep.enemyDefeat: Alignment.centerLeft,
    TutorialStep.exit: Alignment.topCenter,
  };

  /// 애니메이션 타이머 (화살표 스케일)
  double animationTimer = 0.0;
  static const double animationDuration = 1.0;

  TutorialOverlay({
    this.currentStep = TutorialStep.movement,
    this.onTutorialCompleted,
    this.onStepChanged,
  }) : super(
    size: Vector2(0, 0),
  );

  @override
  void onMount() {
    super.onMount();
    // 게임 크기 전체를 커버 (부모의 크기를 사용)
    if (parent != null) {
      size = (parent as PositionComponent).size;
    }
  }

  /// 다음 단계로 진행
  void nextStep() {
    final steps = TutorialStep.values;
    final currentIndex = steps.indexOf(currentStep);

    if (currentIndex < steps.length - 1) {
      currentStep = steps[currentIndex + 1];
      onStepChanged?.call(currentStep);
    } else {
      // 튜토리얼 완료
      removeFromParent();
      onTutorialCompleted?.call();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 화살표 애니메이션
    animationTimer += dt;
    if (animationTimer >= animationDuration) {
      animationTimer -= animationDuration;
    }
  }

  // 탭 처리는 BombermanGame에서 처리

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 반투명 배경 (터치 유도)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()
        ..color = const Color(0x99000000), // 50% 검은색
    );

    // 튜토리얼 텍스트 및 화살표 그리기
    _drawTutorialContent(canvas);
  }

  /// 튜토리얼 콘텐츠 그리기
  void _drawTutorialContent(Canvas canvas) {
    final text = stepTexts[currentStep] ?? '';
    final alignment = arrowAlignments[currentStep] ?? Alignment.center;

    // 텍스트 박스 위치 (중앙 상단)
    final textBoxWidth = 280.0;
    final textBoxHeight = 120.0;
    final textBoxX = (width - textBoxWidth) / 2;
    final textBoxY = height / 3 - textBoxHeight / 2;

    // 텍스트 박스 배경
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(textBoxX, textBoxY, textBoxWidth, textBoxHeight),
        const Radius.circular(16),
      ),
      Paint()
        ..color = const Color(0xFF2C1810)
        ..style = PaintingStyle.fill,
    );

    // 텍스트 박스 테두리
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(textBoxX, textBoxY, textBoxWidth, textBoxHeight),
        const Radius.circular(16),
      ),
      Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // 텍스트 그리기
    _drawTextOnCanvas(canvas, text, textBoxX, textBoxY, textBoxWidth, textBoxHeight);

    // 화살표 그리기
    _drawArrow(canvas, alignment);

    // 건너뛰기 안내 (우측 하단)
    _drawSkipHint(canvas);
  }

  /// 캔버스에 텍스트 그리기
  void _drawTextOnCanvas(
    Canvas canvas,
    String text,
    double x,
    double y,
    double width,
    double height,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: width - 20);
    textPainter.paint(
      canvas,
      Offset(
        x + (width - textPainter.width) / 2,
        y + (height - textPainter.height) / 2,
      ),
    );
  }

  /// 화살표 그리기
  void _drawArrow(Canvas canvas, Alignment alignment) {
    // 펄싱 애니메이션 스케일 (0.8 ~ 1.2)
    final scale = 0.8 + (animationTimer / animationDuration) * 0.4;

    const arrowSize = 50.0;
    const arrowOffsetFromEdge = 80.0;

    // 화살표 위치 계산
    late Offset arrowPos;
    late double arrowRotation;

    switch (alignment) {
      case Alignment.bottomCenter:
        arrowPos = Offset(width / 2, height - arrowOffsetFromEdge);
        arrowRotation = 0; // 아래 방향
        break;
      case Alignment.bottomRight:
        arrowPos = Offset(width - arrowOffsetFromEdge, height - arrowOffsetFromEdge);
        arrowRotation = -0.785; // 왼쪽 위 방향 (-45도)
        break;
      case Alignment.centerRight:
        arrowPos = Offset(width - arrowOffsetFromEdge, height / 2);
        arrowRotation = -1.57; // 왼쪽 방향 (-90도)
        break;
      case Alignment.centerLeft:
        arrowPos = Offset(arrowOffsetFromEdge, height / 2);
        arrowRotation = 1.57; // 오른쪽 방향 (90도)
        break;
      case Alignment.topCenter:
        arrowPos = Offset(width / 2, arrowOffsetFromEdge);
        arrowRotation = 3.14; // 위 방향 (180도)
        break;
      default:
        arrowPos = Offset(width / 2, height / 2);
        arrowRotation = 0;
    }

    // 화살표 그리기
    canvas.save();
    canvas.translate(arrowPos.dx, arrowPos.dy);
    canvas.rotate(arrowRotation);
    canvas.scale(scale);

    // 화살표 삼각형
    final arrowPath = Path();
    arrowPath.moveTo(0, -arrowSize / 2);
    arrowPath.lineTo(-arrowSize / 3, 0);
    arrowPath.lineTo(arrowSize / 3, 0);
    arrowPath.close();

    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = 3
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  /// 건너뛰기 안내 텍스트
  void _drawSkipHint(Canvas canvas) {
    const hintText = '탭하여 다음 단계로';
    const hintFontSize = 14.0;

    final textPainter = TextPainter(
      text: const TextSpan(
        text: hintText,
        style: TextStyle(
          color: Color(0xFFBBBBBB),
          fontSize: hintFontSize,
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        width - textPainter.width - 20,
        height - 40,
      ),
    );
  }
}
