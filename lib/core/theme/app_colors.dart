import 'package:flutter/material.dart';

/// Colour tokens harvested from the "VPN App" Figma file.
///
/// The file defines no variables or styles, so every token below is a raw
/// value that repeats across the eight screens.
abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF087DFF);
  static const primaryLight = Color(0xFFE5F2FF);
  static const cyan = Color(0xFF00B9F2);

  // Text & icons
  static const textPrimary = Color(0xFF182834);
  static const textSecondary = Color(0xFF8395A3);
  static const iconIdle = Color(0xFF8A9EAD);

  // Surfaces
  static const white = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF3F9FD);

  // Lines & tracks
  static const border = Color(0xFFE8F0F6);
  static const borderStrong = Color(0xFFD6E6F0);
  static const progressTrack = Color(0xFFDAEAF5);
  static const mapDots = Color(0xFFD5EAF0);
  static const ribbon = Color(0xFFE4F3FD);
  static const ripple = Color(0xFF0885FF);

  // Status
  static const success = Color(0xFF04C77A);
  static const successLight = Color(0xFFDDF9EC);
  static const danger = Color(0xFFFF3864);
  static const dangerLight = Color(0xFFFFF0F3);
  static const warning = Color(0xFFF2B532);
  static const warningLight = Color(0xFFFFF7E5);
  static const warningDark = Color(0xFFC18A29);
  static const purple = Color(0xFF9770EB);
  static const purpleLight = Color(0xFFF1EAFE);

  // Effects
  static const boltGlow = Color(0xD94DEBFF);
  static const scrim = Color(0xA6142433);
  static const cardShadow = Color(0x0D87B4D0);
  static const powerShadow = Color(0x14087DFF);

  /// Screen background: white fading to [surfaceMuted] at 65 %.
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, surfaceMuted, surfaceMuted],
    stops: [0, 0.65, 1],
  );

  /// Shield logo fill.
  static const brandGradient = LinearGradient(colors: [cyan, primary]);
}
