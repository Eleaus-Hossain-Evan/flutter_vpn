import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/country_name.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/country_flag.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../gen/assets.gen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../home/providers/connection_provider.dart';
import '../../data/server_catalog.dart';
import '../../providers/server_providers.dart';
import '../widgets/signal_bars.dart';

/// Figma "Server details" (7:1631).
///
/// Figma has no motion here; like Choose server, the screen borrows Home's
/// language: one-shot staggered entry fades, a flag pop, a star pop on
/// favouriting and a staggered list reveal.
class ServerDetailsScreen extends HookConsumerWidget {
  const ServerDetailsScreen({super.key, required this.serverId});

  static const route = '/server-details/:id';

  static String location(String id) => '/server-details/$id';

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = serverById(serverId) ?? servers.first;
    final favorite = ref.watch(favoritesProvider).contains(server.id);
    final popStar = useState(false);
    final others = otherServersIn(server);

    Widget star = AppIcon(
      favorite ? Assets.svg.starFilled : Assets.svg.star,
      size: 21,
      // Inside stroke exported doubled, see star.svg.
      strokeWidth: 3.4,
      color: favorite ? AppColors.primary : AppColors.textSecondary,
    );
    if (favorite && popStar.value) {
      star = star
          .animate(key: const ValueKey('star_pop'))
          .scaleXY(begin: 0.6, duration: 450.ms, curve: Curves.elasticOut);
    }

    void connect() {
      ref.read(selectedServerProvider.notifier).select(server.id);
      ref.read(connectedProvider.notifier).set(true);
      context.go(HomeScreen.route);
    }

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              PageHeader(
                title: 'Server Details',
                leading: GestureDetector(
                  key: const ValueKey('details_back'),
                  onTap: () => context.pop(),
                  child: AppIcon(
                    Assets.svg.chevronLeft,
                    size: 25,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: GestureDetector(
                  key: const ValueKey('details_star'),
                  onTap: () => popStar.value = ref
                      .read(favoritesProvider.notifier)
                      .toggle(server.id),
                  child: star,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen.w,
                    10.h,
                    AppSpacing.screen.w,
                    AppSpacing.lg.h + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _fadeIn(_LocationCard(server: server), 0),
                      SizedBox(height: 22.h),
                      _fadeIn(_Performance(pingMs: server.latencyMs), 120),
                      SizedBox(height: 22.h),
                      _fadeIn(_ConnectButton(onPressed: connect), 220),
                      if (others.isNotEmpty) ...[
                        SizedBox(height: 22.h),
                        _fadeIn(
                          // Figma hugs the title; the column stretches.
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Other Servers in ${countryName(context, server.iso)}',
                              style: AppTextStyles.title,
                            ),
                          ),
                          300,
                        ),
                        SizedBox(height: 14.h),
                        _OtherServers(servers: others),
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

  /// One-shot entry: fade and rise, unkeyed so it plays once per visit.
  static Widget _fadeIn(Widget child, int delayMs) => child
      .animate()
      .fadeIn(delay: delayMs.ms, duration: 400.ms, curve: Curves.easeOut)
      .slideY(begin: 0.08, curve: Curves.easeOutCubic);
}

/// Figma "Selected location": flag, country + city, quality chip.
class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.server});

  final Server server;

  @override
  Widget build(BuildContext context) {
    // Figma only shows "Optimal"; weak servers get an amber "Fair".
    final optimal = server.bars >= 3;
    final color = optimal ? AppColors.success : AppColors.warning;

    return Container(
      height: 190.h,
      padding: EdgeInsets.all(AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          CountryFlag(server.iso, size: 56).animate().scaleXY(
            begin: 0.6,
            delay: 100.ms,
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            countryName(context, server.iso),
            style: AppTextStyles.headlineSmall,
          ),
          SizedBox(height: 5.h),
          Text(
            server.city,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: optimal ? AppColors.successLight : AppColors.warningLight,
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(Assets.svg.zap, size: 14, color: color),
                SizedBox(width: 5.w),
                Text(
                  optimal ? 'Optimal' : 'Fair',
                  style: AppTextStyles.captionSemiBold.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma "Server performance": ping, download, upload.
class _Performance extends StatelessWidget {
  const _Performance({required this.pingMs});

  final int pingMs;

  @override
  Widget build(BuildContext context) {
    // Speeds are Figma's values; there is no speed test backend yet.
    final metrics = [
      (
        Assets.svg.orbit,
        AppColors.purple,
        AppColors.purpleLight,
        '$pingMs ms',
        'Ping',
      ),
      (
        Assets.svg.arrowDown,
        AppColors.primary,
        AppColors.primaryLight,
        '32.8 Mbps',
        'Download',
      ),
      (
        Assets.svg.arrowUp,
        AppColors.success,
        AppColors.successLight,
        '12.4 Mbps',
        'Upload',
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, (icon, color, tint, value, label))
              in metrics.indexed) ...[
            if (i > 0) SizedBox(width: AppSpacing.xs.w),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 37.r,
                    height: 37.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tint,
                      shape: BoxShape.circle,
                    ),
                    child: AppIcon(icon, size: 22, color: color),
                  ),
                  SizedBox(height: 9.h),
                  Text(value, style: AppTextStyles.title),
                  SizedBox(height: 5.h),
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Figma "Primary action".
class _ConnectButton extends StatelessWidget {
  const _ConnectButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const ValueKey('details_connect'),
        onTap: onPressed,
        child: SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(Assets.svg.power, size: 20, color: AppColors.white),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                'Connect',
                style: AppTextStyles.button.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma "Alternative servers": white card of 57 px rows.
class _OtherServers extends StatelessWidget {
  const _OtherServers({required this.servers});

  final List<Server> servers;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg.r),
      child: ColoredBox(
        color: AppColors.white,
        child: Column(
          children: [
            for (final (i, s) in servers.indexed)
              _OtherServerRow(
                    server: s,
                    showDivider: i < servers.length - 1,
                    entryDelay: (360 + 50 * i).ms,
                  )
                  .animate()
                  .fadeIn(
                    delay: (360 + 50 * i).ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.15, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}

class _OtherServerRow extends StatelessWidget {
  const _OtherServerRow({
    required this.server,
    required this.showDivider,
    required this.entryDelay,
  });

  final Server server;
  final bool showDivider;
  final Duration entryDelay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey('details_other_${server.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          context.pushReplacement(ServerDetailsScreen.location(server.id)),
      child: Container(
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            CountryFlag(server.iso, size: 29),
            SizedBox(width: 11.w),
            Expanded(
              child: Text(server.city, style: AppTextStyles.labelSemiBold),
            ),
            SizedBox(width: 11.w),
            SignalBars(bars: server.bars, entryDelay: entryDelay),
            SizedBox(width: 11.w),
            SizedBox(
              width: 37.w,
              child: Text(
                '${server.latencyMs} ms',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: 11.w),
            AppIcon(
              Assets.svg.chevronRight,
              size: 17,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
