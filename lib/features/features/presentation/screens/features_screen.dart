import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../gen/assets.gen.dart';
import '../widgets/feature_card.dart';

/// Figma "Features" (7:1817): a 2-column grid of six feature cards.
///
/// Figma has no motion here; the cards enter once, staggered, like the
/// Choose server rows, and the switches slide.
class FeaturesScreen extends HookWidget {
  const FeaturesScreen({super.key});

  static const route = '/features';

  @override
  Widget build(BuildContext context) {
    // Figma's initial switch states.
    final killSwitch = useState(true);
    final adBlocker = useState(true);
    final dnsProtection = useState(true);
    final autoConnect = useState(false);

    final cards = [
      FeatureCard(
        key: const ValueKey('feature_kill_switch'),
        icon: Assets.svg.shieldCheck,
        tint: AppColors.primary,
        title: 'Kill Switch',
        description: 'Block internet if VPN disconnects',
        control: FeatureSwitch(
          value: killSwitch.value,
          onChanged: (v) => killSwitch.value = v,
        ),
      ),
      FeatureCard(
        icon: Assets.svg.columns2,
        tint: AppColors.cyan,
        title: 'Split Tunneling',
        description: 'Choose which apps use VPN',
        control: const FeatureChevron(),
      ),
      FeatureCard(
        icon: Assets.svg.ban,
        tint: AppColors.danger,
        title: 'Ad Blocker',
        description: 'Block ads and trackers',
        control: FeatureSwitch(
          value: adBlocker.value,
          onChanged: (v) => adBlocker.value = v,
        ),
      ),
      FeatureCard(
        icon: Assets.svg.shield,
        tint: AppColors.primary,
        title: 'DNS Leak Protection',
        // Figma sets this one title a size down so it fits on one line.
        compactTitle: true,
        description: 'Prevent DNS leaks',
        control: FeatureSwitch(
          value: dnsProtection.value,
          onChanged: (v) => dnsProtection.value = v,
        ),
      ),
      FeatureCard(
        key: const ValueKey('feature_auto_connect'),
        icon: Assets.svg.zap,
        tint: AppColors.purple,
        title: 'Auto Connect',
        description: 'Connect on app start',
        control: FeatureSwitch(
          key: const ValueKey('feature_auto_connect_switch'),
          value: autoConnect.value,
          onChanged: (v) => autoConnect.value = v,
        ),
      ),
      FeatureCard(
        icon: Assets.svg.settings,
        tint: AppColors.purple,
        title: 'Protocol',
        description: 'WireGuard / OpenVPN',
        control: const FeatureChevron(value: 'Auto (Recommended)'),
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const PageHeader(title: 'Features'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen.w,
                    18.h,
                    AppSpacing.screen.w,
                    AppSpacing.lg.h,
                  ),
                  child: Column(
                    children: [
                      for (var row = 0; row < cards.length; row += 2) ...[
                        if (row > 0) SizedBox(height: AppSpacing.lg.h),
                        Row(
                          children: [
                            Expanded(child: _entry(cards[row], row)),
                            SizedBox(width: 14.w),
                            Expanded(child: _entry(cards[row + 1], row + 1)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// One-shot staggered entry, unkeyed so switch toggles never replay it.
  static Widget _entry(Widget card, int index) => card
      .animate()
      .fadeIn(
        delay: (100 + 60 * index).ms,
        duration: 400.ms,
        curve: Curves.easeOut,
      )
      .slideY(begin: 0.12, curve: Curves.easeOutCubic);
}
