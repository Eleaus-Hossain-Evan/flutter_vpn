import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';

/// A line icon from [Assets.svg] drawn at [size] with a constant [strokeWidth].
///
/// Figma keeps icon strokes at 1.9 px whatever the icon size, so scaling one
/// SVG would thicken or thin the line. The loader rewrites `stroke-width` to
/// keep [strokeWidth] (design px) at every [size] (design px).
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    super.key,
    required this.size,
    this.color,
    this.strokeWidth = 1.9,
  });

  final SvgGenImage asset;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    return SvgPicture(
      _StrokeSvgLoader(asset.path, strokeRatio: strokeWidth / size),
      width: size.r,
      height: size.r,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _StrokeSvgLoader extends SvgAssetLoader {
  const _StrokeSvgLoader(super.assetName, {required this.strokeRatio});

  /// Stroke width as a fraction of the rendered icon width.
  final double strokeRatio;

  static final _viewBoxWidth = RegExp(r'viewBox="[\d.]+ [\d.]+ ([\d.]+)');
  static final _strokeWidth = RegExp(r'stroke-width="[\d.]+"');

  @override
  String provideSvg(ByteData? message) {
    final svg = super.provideSvg(message);
    final width = double.parse(_viewBoxWidth.firstMatch(svg)!.group(1)!);
    return svg.replaceAll(
      _strokeWidth,
      'stroke-width="${strokeRatio * width}"',
    );
  }

  @override
  SvgCacheKey cacheKey(BuildContext? context) => SvgCacheKey(
    theme: getTheme(context),
    colorMapper: colorMapper,
    keyData: (assetName, strokeRatio),
  );

  @override
  int get hashCode => Object.hash(assetName, strokeRatio);

  @override
  bool operator ==(Object other) =>
      other is _StrokeSvgLoader &&
      other.assetName == assetName &&
      other.strokeRatio == strokeRatio;
}
