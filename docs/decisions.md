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
- Asset paths come **only** from flutter_gen (`lib/gen/assets.gen.dart`): `Assets.svg.x.svg(...)`.
  Never hand-write asset path strings or a constants class. After adding an asset run
  `dart run build_runner build --delete-conflicting-outputs`.
- **Countries**: data from `country_code_picker`, flags from `circle_flags` (round vectors). Never
  export flag SVGs from Figma. Render flags with `CountryFlag(iso, size:)` and names with
  `countryName(context, iso)` (`lib/core/`). The package's base names are native, and its
  `translate()` mangles multi-name entries (US, GB), which `countryName` works around. `MaterialApp`
  must register `CountryLocalizations.delegate`.
- Figma inside strokes export as a doubled stroke masked by the shape (e.g. `star.svg`: 3.4 for a
  visible 1.7). Pass that doubled width to `AppIcon(strokeWidth:)`.
- Icon names follow the Figma layer; on a clash with a different-geometry icon, add a suffix
  (`star_rounded` = Profile's Lucide star; `star` = the server-list favourite star).
- Line icons render with `AppIcon(Assets.svg.x, size: …)` (`lib/core/widgets/app_icon.dart`). Figma
  keeps icon strokes at 1.9 px at every size; `AppIcon` rewrites `stroke-width` so one SVG per icon
  stays exact at any size (`strokeWidth:` overrides, e.g. 4 for the 57 px power glyph).
- Inter is **bundled** (static TTFs, v3.19 — the version Figma uses) in `assets/fonts/`, weights
  400/500/600/700/800. No `google_fonts`.
- Sizing: `flutter_screenutil`, design size 390 × 844 (`.w` / `.h` / `.sp` / `.r`).
- Routing: `go_router`, config in `lib/core/router/app_router.dart` (`createAppRouter`); each
  screen exposes `static const route`. Home, Features and Profile are branches of a
  `StatefulShellRoute` whose shell (`AppShell`, `lib/core/router/app_shell.dart`) owns the bottom
  nav and the drawer. Choose server and Server details are pushed over the shell (they have back
  buttons and no nav in Figma). Tab screens keep their own `Scaffold`; open the drawer with
  `AppShell.openDrawer(context)`.
- Local UI state: `flutter_hooks` (`HookWidget`).
- Cross-screen state: plain Riverpod `Notifier`s (no codegen) under `lib/features/<f>/providers/`:
  `connectedProvider`, `selectedServerProvider`, `favoritesProvider`. `ProviderScope` is in
  `main.dart` and in the test harness.
- Server data: `lib/features/servers/data/server_catalog.dart` (`Server` record, Figma's 10 servers
  plus the 3 US cities only Server details shows).

## Structure

- Features: `lib/features/<feature>/presentation/{screens,widgets}/`.
- Extract a widget only when it is used in two or more places. `MenuTile` (Figma "Menu item") is
  shared by Profile and the drawer; `PageHeader` by every pushed/tab screen.
- Figma Motion timelines are reproduced from `get_motion_context` keyframes. A keyframe's easing
  shapes the segment that *arrives* at it.

## Animation

- Use `flutter_animate` first; plain Flutter (`AnimatedSwitcher`, `TweenAnimationBuilder`,
  `CustomPainter`) only where it can't express the effect.
- **Entry animations play once per screen entry**: unkeyed `.animate()` at a stable tree position.
  Never key an entry animation on UI state — that replays it on every state change.
- State transitions: `.animate(target: state ? 1 : 0)` for reversible effects; one-shot effects
  are widgets mounted only in the new state (they `.animate()` on mount); content swaps use
  `SlideFadeSwitcher` (`lib/core/widgets/slide_fade_switcher.dart`).
- Implicit animations (`AnimatedAlign`, …) in tests also need `pump()` before a timed pump.
- Widget tests: flutter_animate starts on a deferred timer and its first ticker frame only records
  the start, so pump `()`, then `16 ms`, then the duration.

## Verification workflow

1. `dart format`, `flutter analyze`, `flutter test`.
2. A widget test at 390 × 844 with Inter loaded asserts key sizes/positions against Figma
   (`test/helpers/design_harness.dart`: `useFigmaFrame`, `designApp`, `expectRect`, `settleEntry`,
   `tearDownApp`). `useFigmaFrame` clears `rootBundle`'s cache after each test: a cached asset
   future from a previous test's fake-async zone never completes, which leaves
   `CountryLocalizations` (and the whole app) unloaded.
3. Visual check: connect Marionette to the already-running app (ask for the VM service URI; never
   `flutter run`, never hot restart unprompted), one screenshot, compare with Figwright
   `get_screenshot` of the same frame.
4. `design_diff` on the frame saves a baseline under `.figwright/snapshots/`.
