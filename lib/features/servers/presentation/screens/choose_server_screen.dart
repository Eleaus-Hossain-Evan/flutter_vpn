import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../gen/assets.gen.dart';
import '../../data/server_catalog.dart';
import '../../providers/server_providers.dart';
import '../widgets/server_row.dart';
import 'server_details_screen.dart';

const _tabs = ['All', 'Favorites', 'Streaming', 'Gaming'];

/// Figma "Choose server" (7:1427).
///
/// Figma has no motion here; the screen borrows Home's language: one-shot
/// entry fades with a staggered row reveal, a sliding tab pill, a star pop
/// and a refresh spin. Tapping a row selects it and opens Server details.
class ChooseServerScreen extends HookConsumerWidget {
  const ChooseServerScreen({super.key});

  static const route = '/servers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = useState(0);
    final selectedId = ref.watch(selectedServerProvider);
    final favorites = ref.watch(favoritesProvider);
    final poppedStarId = useState<String?>(null);
    final refreshTurns = useState(0);

    // Streaming and Gaming have no data in Figma yet, so they list everything.
    final visible = tab.value == 1
        ? servers.where((s) => favorites.contains(s.id)).toList()
        : servers;

    void toggleFavorite(String id) {
      if (ref.read(favoritesProvider.notifier).toggle(id)) {
        poppedStarId.value = id;
      }
    }

    void open(String id) {
      ref.read(selectedServerProvider.notifier).select(id);
      context.push(ServerDetailsScreen.location(id));
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
                title: 'Choose Server',
                leading: GestureDetector(
                  key: const ValueKey('servers_back'),
                  onTap: () => context.pop(),
                  child: AppIcon(
                    Assets.svg.chevronLeft,
                    size: 25,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: GestureDetector(
                  key: const ValueKey('servers_refresh'),
                  onTap: () => refreshTurns.value++,
                  child: AnimatedRotation(
                    turns: refreshTurns.value.toDouble(),
                    duration: 700.ms,
                    curve: Curves.easeInOutCubic,
                    child: AppIcon(
                      Assets.svg.refreshCw,
                      size: 23,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  AppSpacing.sm.h,
                  AppSpacing.lg.w,
                  0,
                ),
                child:
                    _CategoryTabs(
                      selected: tab.value,
                      onSelect: (i) => tab.value = i,
                    ).animate().fadeIn(
                      delay: 100.ms,
                      duration: 450.ms,
                      curve: Curves.easeOut,
                    ),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg.w,
                    0,
                    AppSpacing.lg.w,
                    AppSpacing.lg.h + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: AnimatedSize(
                    duration: 250.ms,
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg.r),
                      child: ColoredBox(
                        color: AppColors.white,
                        child: Column(
                          children: [
                            for (final (i, s) in visible.indexed)
                              _entry(
                                index: i,
                                child: ServerRow(
                                  id: s.id,
                                  isoCode: s.iso,
                                  city: s.city,
                                  latencyMs: s.latencyMs,
                                  bars: s.bars,
                                  selected: s.id == selectedId,
                                  favorite: favorites.contains(s.id),
                                  popStar: s.id == poppedStarId.value,
                                  showDivider: i < visible.length - 1,
                                  entryDelay: _rowDelay(i),
                                  onTap: () => open(s.id),
                                  onToggleFavorite: () => toggleFavorite(s.id),
                                ),
                                id: s.id,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Duration _rowDelay(int index) => (150 + 45 * index).ms;

  /// One-shot staggered reveal: a row fades and rises when it first mounts
  /// (screen entry, or reappearing after the Favorites filter).
  static Widget _entry({
    required int index,
    required String id,
    required Widget child,
  }) {
    return child
        .animate(key: ValueKey('server_row_$id'))
        .fadeIn(
          delay: _rowDelay(index),
          duration: 400.ms,
          curve: Curves.easeOut,
        )
        .slideY(begin: 0.15, curve: Curves.easeOutCubic);
  }
}

/// Figma "Server categories": white track, sliding primary pill.
class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final gap = 3.w;

    return Container(
      height: 44.h,
      padding: EdgeInsets.all(AppSpacing.xxs.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - gap * 3) / _tabs.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: 250.ms,
                curve: Curves.easeOutCubic,
                left: selected * (tabWidth + gap),
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final (i, label) in _tabs.indexed) ...[
                    if (i > 0) SizedBox(width: gap),
                    Expanded(
                      child: GestureDetector(
                        key: ValueKey('servers_tab_$i'),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onSelect(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: 250.ms,
                            style: AppTextStyles.captionSemiBold.copyWith(
                              color: i == selected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                            ),
                            child: Text(label),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
