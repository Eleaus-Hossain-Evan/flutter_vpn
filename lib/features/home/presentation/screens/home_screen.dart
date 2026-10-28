import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/slide_fade_switcher.dart';
import '../../../../gen/assets.gen.dart';
import '../widgets/connection_metrics_card.dart';
import '../widgets/power_button.dart';
import '../widgets/selected_server_card.dart';

/// Figma "Home · Not connected" (7:1243) and "Home · Connected" (7:1324).
///
/// Tapping the power button connects; "Disconnect" returns to the first
/// state. Each state change replays the Figma entrance fades.
class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    final connected = useState(false);

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SafeArea(bottom: false, child: _AppHeader()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen.w,
                  AppSpacing.sm.h,
                  AppSpacing.screen.w,
                  AppSpacing.lg.h,
                ),
                child: _Dashboard(
                  connected: connected.value,
                  onConnect: () => connected.value = true,
                  onDisconnect: () => connected.value = false,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: 0, onTap: (_) {}),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.header.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            key: const ValueKey('home_menu_button'),
            onTap: () {},
            child: AppIcon(
              Assets.svg.menu,
              size: 23,
              color: AppColors.textPrimary,
            ),
          ),
          const BrandLogo(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(Assets.svg.crown, size: 16, color: AppColors.warning),
                SizedBox(width: AppSpacing.xxs.w),
                Text(
                  'PRO',
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.connected,
    required this.onConnect,
    required this.onDisconnect,
  });

  final bool connected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  /// Figma entrance fade: hold, then 450 ms ease-out to opaque.
  ///
  /// Unkeyed on purpose: it plays once when Home mounts and never on a
  /// connect/disconnect rebuild. State swaps animate inside the child.
  Widget _fadeIn(Widget child, int delayMs) => child.animate().fadeIn(
    delay: delayMs.ms,
    duration: 450.ms,
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.lg.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 314.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 10.h,
                left: 0,
                right: 0,
                height: 182.h,
                child: Assets.svg.worldMap.svg(fit: BoxFit.fill),
              ),
              Padding(
                padding: EdgeInsets.only(top: 38.h),
                child: Column(
                  children: [
                    PowerButton(
                      key: const ValueKey('home_power_button'),
                      connected: connected,
                      onTap: connected ? null : onConnect,
                    ),
                    SizedBox(height: 22.h),
                    _fadeIn(_StatusText(connected: connected), 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        gap,
        _fadeIn(SelectedServerCard(connected: connected), 220),
        gap,
        _fadeIn(ConnectionMetricsCard(connected: connected), 340),
        gap,
        SizedBox(
          height: 50.h,
          child: SlideFadeSwitcher(
            offsetY: 0.4,
            expand: true,
            child: connected
                ? _DisconnectButton(onPressed: onDisconnect)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppColors.success : AppColors.textSecondary;

    // Crossfade only — no slide for the status text.
    return SlideFadeSwitcher(
      offsetY: 0,
      alignment: Alignment.topCenter,
      child: Column(
        key: ValueKey(connected),
        children: [
          Text(
            connected ? 'Connected' : 'Not Connected',
            style: AppTextStyles.headline,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (connected) ...[
                AppIcon(
                  Assets.svg.shieldCheck,
                  size: 15,
                  color: color,
                ).animate().scale(
                  begin: Offset.zero,
                  delay: 150.ms,
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
                SizedBox(width: 5.w),
              ],
              Text(
                connected ? 'Your connection is secure' : 'Tap to connect',
                style: AppTextStyles.bodySmall.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DisconnectButton extends StatelessWidget {
  const _DisconnectButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.danger,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const ValueKey('home_disconnect_button'),
        onTap: onPressed,
        child: Center(
          child: Text(
            'Disconnect',
            style: AppTextStyles.button.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
