# Build progress — Figma "VPN App" → Flutter

Screens are built **one at a time**, in the order below. A screen is "done" only after
`flutter analyze`, `flutter test` and a visual check against Figma on the emulator.

Figma file: **VPN App** (opened through the Figwright MCP plugin). All frames are 390 × 844.

| # | Screen | Figma node | Status |
|---|---|---|---|
| 1 | Splash screen | `7:1219` | Done — verified on emulator, baseline `.figwright/snapshots/7-1219.json` |
| 2 | Home · Not connected | `7:1243` | Done — confirmed by user |
| 3 | Home · Connected | `7:1324` | Done — same screen as #2, confirmed by user |
| 4 | Choose server | `7:1427` | Built — tests pass; visual check pending (needs app restart) |
| 5 | Server details | `7:1631` | Built — tests pass; visual check pending |
| 6 | Features | `7:1817` | Built — tests pass; visual check pending |
| 7 | Profile and settings | `7:1901` | Built — tests pass; visual check pending |
| 8 | Navigation drawer | `7:1969` | Built — tests pass; visual check pending |

## Next step

All 8 screens are built. Next: restart the app (new router shell, new assets) and visually check
screens 4–8 against Figma, one screenshot each, then `design_diff` baselines. Not wired (no Figma
screens): drawer items Connection History / Settings / Share App / Help & Support / About, Profile
rows, Log Out, Upgrade cards, Split Tunneling / Protocol chevrons.

## Open items

- Strings are literals: the project has no l10n setup yet (needs `flutter_localizations` + `intl`,
  not approved yet).
- Splash timeline plays once; Figma does not record whether it loops.
- Home connect/disconnect motion (ring ignite + bloom, sparks, glyph flicker, soft ripple, metric
  count-up, card/text swaps) is user-requested design, not in Figma (no prototype reactions).
- Choose server: Streaming / Gaming tabs list every server (no category data in Figma); list is
  Figma's 10 servers as static data; refresh only spins the icon (no backend). Its motion (entry
  stagger, signal-bar grow, tab pill, star pop, refresh spin) is improvised; Figma has none.
- Server details: download / upload values are Figma's static numbers for every server (no speed
  test); ping is the server's latency. Quality chip shows Figma's "Optimal" for 3-bar servers and an
  improvised amber "Fair" for weaker ones. "Other servers" lists the same country's servers (only
  the US has any). Connect selects the server, connects and goes to Home.
- Features switches and Profile have local / no state (no backend). Drawer highlights Home or
  Features (the current tab); Profile has no drawer entry in Figma.
- Motion on Server details, Features, Profile and the drawer is improvised (Figma has none):
  one-shot staggered fade + rise entries, flag pop, star pop, switch slide, drawer items slide in on
  each opening.
- Flags now come from circle_flags, whose designs differ slightly from Figma's simplified flags.
- Scale pivots for the splash shield and ripples are assumed to be the centre.
- `lib/main.dart`: `sharedPreferences` in `_bootstrap` is unused (pre-existing analyzer warning).

## Log

- 2026-10-29 — Theme tokens harvested from all 8 frames; splash screen built with the full Figma
  Motion timeline; geometry asserted in `test/splash_screen_test.dart`; visual check passed.
- 2026-10-29 — Home built (both states, Figma motion: halo pulse + one-shot entry fades). Added
  flutter_gen (`package_parameter_enabled: false`), `AppIcon`, `BrandLogo`, `AppBottomNav`,
  `SlideFadeSwitcher`; splash → Home navigation; connect/disconnect transition effects.
- 2026-10-29 — Choose server built: country_code_picker + circle_flags (`CountryFlag`,
  `countryName`), shared `PageHeader`, `SignalBars`, `ServerRow`; Home server card and Servers tab
  open it; Home's connected flag switched to `CountryFlag`.
- 2026-10-29 — Server details, Features, Profile and Navigation drawer built. Router moved to a
  `StatefulShellRoute` (`AppShell`: bottom nav + drawer); connection, selected server and
  favourites moved to Riverpod notifiers; shared `MenuTile`; 11 icons exported; token
  `labelSemiBold` (13/600) added; server data moved to `server_catalog.dart`.
