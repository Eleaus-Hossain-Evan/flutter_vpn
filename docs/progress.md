# Build progress — Figma "VPN App" → Flutter

Screens are built **one at a time**, in the order below. A screen is "done" only after
`flutter analyze`, `flutter test` and a visual check against Figma on the emulator.

Figma file: **VPN App** (opened through the Figwright MCP plugin). All frames are 390 × 844.

| # | Screen | Figma node | Status |
|---|---|---|---|
| 1 | Splash screen | `7:1219` | Done — verified on emulator, baseline `.figwright/snapshots/7-1219.json` |
| 2 | Home · Not connected | `7:1243` | Built — tests pass; visual check pending (needs app restart) |
| 3 | Home · Connected | `7:1324` | Built — same screen as #2; visual check pending |
| 4 | Choose server | `7:1427` | Planned |
| 5 | Server details | `7:1631` | Planned |
| 6 | Features | `7:1817` | Planned |
| 7 | Profile and settings | `7:1901` | Planned |
| 8 | Navigation drawer | `7:1969` | Planned |

## Next step

Visual check of Home (both states) on the emulator against Figma, then build Choose server
(`7:1427`). Home's menu (→ drawer), server card (→ Choose server) and nav tabs are not wired yet.

## Open items

- Strings are literals: the project has no l10n setup yet (needs `flutter_localizations` + `intl`,
  not approved yet).
- Splash timeline plays once; Figma does not record whether it loops.
- Home connect/disconnect motion (ring ignite + bloom, sparks, glyph flicker, soft ripple, metric
  count-up, card/text swaps) is user-requested design, not in Figma (no prototype reactions).
- Scale pivots for the splash shield and ripples are assumed to be the centre.
- `lib/main.dart`: `sharedPreferences` in `_bootstrap` is unused (pre-existing analyzer warning).

## Log

- 2026-10-29 — Theme tokens harvested from all 8 frames; splash screen built with the full Figma
  Motion timeline; geometry asserted in `test/splash_screen_test.dart`; visual check passed.
- 2026-10-29 — Home built (both states, Figma motion: halo pulse + one-shot entry fades). Added
  flutter_gen (`package_parameter_enabled: false`), `AppIcon`, `BrandLogo`, `AppBottomNav`,
  `SlideFadeSwitcher`; splash → Home navigation; connect/disconnect transition effects.
