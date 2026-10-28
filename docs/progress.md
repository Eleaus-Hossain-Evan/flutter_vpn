# Build progress — Figma "VPN App" → Flutter

Screens are built **one at a time**, in the order below. A screen is "done" only after
`flutter analyze`, `flutter test` and a visual check against Figma on the emulator.

Figma file: **VPN App** (opened through the Figwright MCP plugin). All frames are 390 × 844.

| # | Screen | Figma node | Status |
|---|---|---|---|
| 1 | Splash screen | `7:1219` | Done — verified on emulator, baseline `.figwright/snapshots/7-1219.json` |
| 2 | Home · Not connected | `7:1243` | **Next** |
| 3 | Home · Connected | `7:1324` | Planned — same screen as #2, connection state switches |
| 4 | Choose server | `7:1427` | Planned |
| 5 | Server details | `7:1631` | Planned |
| 6 | Features | `7:1817` | Planned |
| 7 | Profile and settings | `7:1901` | Planned |
| 8 | Navigation drawer | `7:1969` | Planned |

## Next step

Build Home (`7:1243` + `7:1324`) as one screen with a not-connected / connected state, and make
the splash navigate to Home when its 4 s timeline ends (splash currently stays on screen).

## Open items

- Strings are literals: the project has no l10n setup yet (needs `flutter_localizations` + `intl`,
  not approved yet).
- Splash timeline plays once; Figma does not record whether it loops.
- Scale pivots for the splash shield and ripples are assumed to be the centre.
- `lib/main.dart`: `sharedPreferences` in `_bootstrap` is unused (pre-existing analyzer warning).

## Log

- 2026-10-29 — Theme tokens harvested from all 8 frames; splash screen built with the full Figma
  Motion timeline; geometry asserted in `test/splash_screen_test.dart`; visual check passed.
