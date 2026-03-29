import 'package:flutter/material.dart';

/// 최적화된 위젯들 (const 활용)

/// 최적화된 텍스트 스타일
class OptimizedTextStyles {
  // Const로 정의하여 재사용성 높임
  static const TextStyle titleLarge = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: Color(0xFF8B0000),
    letterSpacing: 2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
    letterSpacing: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    color: Color(0xFFFFFFFF),
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle accent = TextStyle(
    fontSize: 18,
    color: Color(0xFFFFD700),
    fontWeight: FontWeight.bold,
  );
}

/// 최적화된 버튼 스타일
class OptimizedButtonStyles {
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(16));
  static const EdgeInsets largePadding = EdgeInsets.all(24);
}

/// 최적화된 간격 상수
class OptimizedSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// 최적화된 색상 상수
class OptimizedColors {
  static const Color background = Color(0xFF2C1810);
  static const Color surface = Color(0xFF1a1a1a);
  static const Color primary = Color(0xFF8B0000);
  static const Color accent = Color(0xFFFFD700);
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFBBBBBB);
}

/// 최적화된 간단한 위젯들

/// 분리된 SizedBox (const 위젯 분리)
class SizedBoxH4 extends SizedBox {
  const SizedBoxH4() : super(height: 4);
}

class SizedBoxH8 extends SizedBox {
  const SizedBoxH8() : super(height: 8);
}

class SizedBoxH16 extends SizedBox {
  const SizedBoxH16() : super(height: 16);
}

class SizedBoxH24 extends SizedBox {
  const SizedBoxH24() : super(height: 24);
}

class SizedBoxH32 extends SizedBox {
  const SizedBoxH32() : super(height: 32);
}

class SizedBoxH48 extends SizedBox {
  const SizedBoxH48() : super(height: 48);
}

class SizedBoxW8 extends SizedBox {
  const SizedBoxW8() : super(width: 8);
}

class SizedBoxW16 extends SizedBox {
  const SizedBoxW16() : super(width: 16);
}

/// 최적화된 Divider
class OptimizedDivider extends Divider {
  const OptimizedDivider({Key? key})
      : super(
          key: key,
          color: const Color(0xFF444444),
          height: 1,
          thickness: 1,
        );
}

/// 최적화된 배경 컨테이너
class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const BackgroundContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? OptimizedColors.surface,
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(12)),
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

/// 최적화된 텍스트 위젯 (const 스타일)
class TitleText extends Text {
  const TitleText(
    String data, {
    Key? key,
    TextAlign? textAlign,
  }) : super(
    data,
    key: key,
    style: OptimizedTextStyles.titleMedium,
    textAlign: textAlign ?? TextAlign.center,
  );
}

class AccentText extends Text {
  const AccentText(
    String data, {
    Key? key,
    TextAlign? textAlign,
  }) : super(
    data,
    key: key,
    style: OptimizedTextStyles.accent,
    textAlign: textAlign ?? TextAlign.center,
  );
}

class BodyText extends Text {
  const BodyText(
    String data, {
    Key? key,
    TextAlign? textAlign,
  }) : super(
    data,
    key: key,
    style: OptimizedTextStyles.bodyMedium,
    textAlign: textAlign ?? TextAlign.start,
  );
}
