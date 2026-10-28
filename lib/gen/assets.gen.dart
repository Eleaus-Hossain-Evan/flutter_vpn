// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $LibGen {
  const $LibGen();

  /// File path: lib/riverpod_dependencies.json
  String get riverpodDependencies => 'lib/riverpod_dependencies.json';

  /// List of all assets
  List<String> get values => [riverpodDependencies];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/arrow_down.svg
  SvgGenImage get arrowDown => const SvgGenImage('assets/svg/arrow_down.svg');

  /// File path: assets/svg/arrow_up.svg
  SvgGenImage get arrowUp => const SvgGenImage('assets/svg/arrow_up.svg');

  /// File path: assets/svg/background_ribbon.svg
  SvgGenImage get backgroundRibbon =>
      const SvgGenImage('assets/svg/background_ribbon.svg');

  /// File path: assets/svg/ban.svg
  SvgGenImage get ban => const SvgGenImage('assets/svg/ban.svg');

  /// File path: assets/svg/chevron_left.svg
  SvgGenImage get chevronLeft =>
      const SvgGenImage('assets/svg/chevron_left.svg');

  /// File path: assets/svg/chevron_right.svg
  SvgGenImage get chevronRight =>
      const SvgGenImage('assets/svg/chevron_right.svg');

  /// File path: assets/svg/clock_3.svg
  SvgGenImage get clock3 => const SvgGenImage('assets/svg/clock_3.svg');

  /// File path: assets/svg/columns_2.svg
  SvgGenImage get columns2 => const SvgGenImage('assets/svg/columns_2.svg');

  /// File path: assets/svg/crown.svg
  SvgGenImage get crown => const SvgGenImage('assets/svg/crown.svg');

  /// File path: assets/svg/globe.svg
  SvgGenImage get globe => const SvgGenImage('assets/svg/globe.svg');

  /// File path: assets/svg/headset.svg
  SvgGenImage get headset => const SvgGenImage('assets/svg/headset.svg');

  /// File path: assets/svg/history.svg
  SvgGenImage get history => const SvgGenImage('assets/svg/history.svg');

  /// File path: assets/svg/house.svg
  SvgGenImage get house => const SvgGenImage('assets/svg/house.svg');

  /// File path: assets/svg/info.svg
  SvgGenImage get info => const SvgGenImage('assets/svg/info.svg');

  /// File path: assets/svg/lightning_bolt.svg
  SvgGenImage get lightningBolt =>
      const SvgGenImage('assets/svg/lightning_bolt.svg');

  /// File path: assets/svg/menu.svg
  SvgGenImage get menu => const SvgGenImage('assets/svg/menu.svg');

  /// File path: assets/svg/orbit.svg
  SvgGenImage get orbit => const SvgGenImage('assets/svg/orbit.svg');

  /// File path: assets/svg/power.svg
  SvgGenImage get power => const SvgGenImage('assets/svg/power.svg');

  /// File path: assets/svg/refresh_cw.svg
  SvgGenImage get refreshCw => const SvgGenImage('assets/svg/refresh_cw.svg');

  /// File path: assets/svg/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/svg/settings.svg');

  /// File path: assets/svg/share_2.svg
  SvgGenImage get share2 => const SvgGenImage('assets/svg/share_2.svg');

  /// File path: assets/svg/shield.svg
  SvgGenImage get shield => const SvgGenImage('assets/svg/shield.svg');

  /// File path: assets/svg/shield_check.svg
  SvgGenImage get shieldCheck =>
      const SvgGenImage('assets/svg/shield_check.svg');

  /// File path: assets/svg/shield_silhouette.svg
  SvgGenImage get shieldSilhouette =>
      const SvgGenImage('assets/svg/shield_silhouette.svg');

  /// File path: assets/svg/sliders_horizontal.svg
  SvgGenImage get slidersHorizontal =>
      const SvgGenImage('assets/svg/sliders_horizontal.svg');

  /// File path: assets/svg/star.svg
  SvgGenImage get star => const SvgGenImage('assets/svg/star.svg');

  /// File path: assets/svg/star_filled.svg
  SvgGenImage get starFilled => const SvgGenImage('assets/svg/star_filled.svg');

  /// File path: assets/svg/star_rounded.svg
  SvgGenImage get starRounded =>
      const SvgGenImage('assets/svg/star_rounded.svg');

  /// File path: assets/svg/user_round.svg
  SvgGenImage get userRound => const SvgGenImage('assets/svg/user_round.svg');

  /// File path: assets/svg/world_map.svg
  SvgGenImage get worldMap => const SvgGenImage('assets/svg/world_map.svg');

  /// File path: assets/svg/x.svg
  SvgGenImage get x => const SvgGenImage('assets/svg/x.svg');

  /// File path: assets/svg/zap.svg
  SvgGenImage get zap => const SvgGenImage('assets/svg/zap.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    arrowDown,
    arrowUp,
    backgroundRibbon,
    ban,
    chevronLeft,
    chevronRight,
    clock3,
    columns2,
    crown,
    globe,
    headset,
    history,
    house,
    info,
    lightningBolt,
    menu,
    orbit,
    power,
    refreshCw,
    settings,
    share2,
    shield,
    shieldCheck,
    shieldSilhouette,
    slidersHorizontal,
    star,
    starFilled,
    starRounded,
    userRound,
    worldMap,
    x,
    zap,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $LibGen lib = $LibGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
