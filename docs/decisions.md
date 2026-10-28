# Project decisions

Decisions already made for this project. Follow them; change one only after asking.

## Design source

- The Figma file defines **no variables and no styles**. Every token in `lib/core/theme/` was
  harvested from raw values repeated across the 8 frames. New screens reuse these tokens; a value
  with no token is used raw and listed as a gap.
- Figma's "Auto" line height for Inter is emitted as `height: 1.21`, and every text style sets
  `letterSpacing: 0`. Without both, Material 3's `DefaultTextStyle` (height 1.43, tracking 0.25)
  leaks in and text renders ~4 % wider than Figma.

## Tokens (`lib/core/theme/`)

| File | Contents |
|---|---|
| `app_colors.dart` | `AppColors` — brand, text, surfaces, lines, status colours + light tints, effects, background and brand gradients |
| `app_text_styles.dart` | `AppTextStyles` — 24 Inter styles named by role (`brandLarge` 31/800 … `tiny` 9/600) |
| `app_spacing.dart` | `AppSpacing`, `AppRadius`, `AppShadows` |
| `app_theme.dart` | `AppTheme.light` |

## Packages and assets

- `flutter_svg` for every Figma vector. SVGs live in `assets/svg/`, named after the Figma layer in
  snake_case. Strip SVG filters (flutter_svg ignores them) and recreate effects in Flutter.
- Inter is **bundled** (static TTFs, v3.19 — the version Figma uses) in `assets/fonts/`, weights
  400/500/600/700/800. No `google_fonts`.
- Sizing: `flutter_screenutil`, design size 390 × 844 (`.w` / `.h` / `.sp` / `.r`).
- Routing: `go_router`, config in `lib/core/router/app_router.dart`; each screen exposes
  `static const route`.
- Local UI state: `flutter_hooks` (`HookWidget`).

## Structure

- Features: `lib/features/<feature>/presentation/{screens,widgets}/`.
- Extract a widget only when it is used in two or more places.
- Figma Motion timelines are reproduced from `get_motion_context` keyframes. A keyframe's easing
  shapes the segment that *arrives* at it.

## Verification workflow

1. `dart format`, `flutter analyze`, `flutter test`.
2. A widget test at 390 × 844 with Inter loaded asserts key sizes/positions against Figma.
3. Visual check: connect Marionette to the already-running app (ask for the VM service URI; never
   `flutter run`, never hot restart unprompted), one screenshot, compare with Figwright
   `get_screenshot` of the same frame.
4. `design_diff` on the frame saves a baseline under `.figwright/snapshots/`.
