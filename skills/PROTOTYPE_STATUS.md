# Overman_V0 --- Prototype Status

> This file is the source of truth for prototype progress. Update it
> after each implementation task. Record observed results, not
> intentions. Never mark something as tested unless the relevant command
> or app flow was actually run.

## Current milestone

**Target:** Working multi-screen prototype for the October 16 college
presentation.

## Current status

- Overall: Backend ready; TASK-01 (theme & tokens), TASK-02 (Home screen & habit card), TASK-03 (Add Habit screen for boolean & numeric habits), and TASK-05 (expanded habit card with circular panels: Heatmap, Statistics, Trend Graph, and Details) complete.
- Last updated: 2026-10-14 09:30 IST
- Current branch/commit: `overman` / `d4d8578`
- Target device/emulator: Windows desktop & Android compact frame (412×917)
- App launches: ✅ Verified via widget testing and app compilation (`HomeScreen`, `AddHabitScreen`, and expanded `HabitCard` active)

## Working features

- [x] Local persistence across app restart (ObjectBox on `getApplicationDocumentsDirectory()`)
- [x] Dark design system tokens & application theme (`AppColors`, `AppTheme.darkTheme`)
- [x] Home screen layout
- [x] Home navigation (navigation from Home to Add screen and back)
- [x] Add habit (boolean and numeric habit creation form with schedules, units, targets, colors, and icons)
- [ ] Add one-off task (intentionally skipped per user directive; deferred to a later step)
- [x] Checkmark completion (implemented via reactive `EntryActions.logEntry/deleteEntry` in `HomeScreen`)
- [x] Numeric value logging (implemented via bottom sheet in `HomeScreen`)
- [x] Expanded habit card
- [x] Heatmap panel
- [x] Statistics panel
- [x] Numeric graph panel
- [x] Circular swipe/arrow navigation
- [ ] Edit habit
- [ ] Delete habit with confirmation
- [ ] History screen
- [ ] Insights screen
- [ ] Settings screen
- [ ] CSV export
- [ ] JSON export
- [ ] XLSX export
- [ ] Final demonstration walkthrough

## Latest completed task

**Task ID:** TASK-05 — Expanded habit card with Heatmap, Statistics, Trend Graph, and Details panels
- Implemented:
  - Created `lib/presentation/widgets/heatmap_panel.dart`:
    - Responsive streak badges (`currentStreak`, `longestStreak`).
    - 28-day (4-week) Monday–Sunday calendar grid styled according to `DayStatus`.
    - Distinct today-indicator (orange border), future day handling, and color legend.
  - Created `lib/presentation/widgets/statistics_panel.dart`:
    - 365-day range metrics computed via `habitStatisticsProvider`.
    - Displays completion rate percentage, completed days, missed days, and habit consistency.
    - For numeric habits: displays daily average, best record, and total logged sum with units.
    - Responsive layout preventing RenderFlex overflows on narrow frames.
  - Created `lib/presentation/widgets/numeric_graph_panel.dart`:
    - 7-day trend bar graph consuming `habitEntriesProvider` for numeric habits only.
    - Displays proportional bar heights, target goal line indicator, and weekday labels.
  - Created `lib/presentation/widgets/details_panel.dart`:
    - Displays habit start date (`createdAt`), schedule display name, tracking type, and numeric targets.
    - Flexible row layout with truncation for compact viewports.
  - Updated `lib/presentation/widgets/habit_card.dart`:
    - Converted to `ConsumerStatefulWidget` managing in-place animated expansion via `AnimatedSize`.
    - Circular panel carousel header with `< [PANEL NAME] >` previous/next navigation and dot indicators.
    - Added horizontal swipe gesture navigation (`onHorizontalDragEnd`).
    - Sequence for boolean habits: `Heatmap → Statistics → Details → Heatmap`.
    - Sequence for numeric habits: `Heatmap → Statistics → Trend Graph → Details → Heatmap`.
    - Design requirement: Reopening a collapsed card always resets active panel to Heatmap.
    - Completion action button taps isolated from card expansion.
  - Updated `lib/presentation/screens/home/home_screen.dart`:
    - Removed placeholder tap snackbar so in-place expansion handles card tap cleanly.
  - Updated `test/widget_test.dart`:
    - Added test for in-place card expansion, heatmap rendering, circular navigation, and reopen reset.
    - Added test for numeric habit panel sequence including the 7-day trend graph.
    - Configured ObjectBox store in widget test harness.
- Files changed:
  - `lib/presentation/widgets/heatmap_panel.dart` (new)
  - `lib/presentation/widgets/statistics_panel.dart` (new)
  - `lib/presentation/widgets/numeric_graph_panel.dart` (new)
  - `lib/presentation/widgets/details_panel.dart` (new)
  - `lib/presentation/widgets/habit_card.dart` (modified)
  - `lib/presentation/screens/home/home_screen.dart` (modified)
  - `test/widget_test.dart` (modified)
- Tests/checks run:
  - `flutter analyze lib/` → ✅ `No issues found! (ran in 10.6s)`
  - `flutter test` → ✅ `All tests passed! (74/74 passed)`
- Observed result:
  - Zero analysis issues in `lib/`.
  - All 74 tests pass across data, domain, repository, and widget suites.
- Known limitations:
  - One-off tasks omitted from Add screen as requested.

## Current task

**Task ID:** TASK-06 — Wire navigation and remaining prototype screens
- Goal: Wire navigation to remaining prototype screens (History, Insights, Settings placeholders/views).
- Acceptance criteria:
  - Navigation controls on HomeScreen (History button in header, Settings button in header) navigate to functional or prototype stub screens.
  - `flutter analyze lib/` reports 0 issues.
  - `flutter test` passes.

## Remaining work --- ordered by priority

### P0 --- Required for demonstration

- [x] TASK-01: Design tokens + app theme (`app_theme.dart`)
- [x] TASK-02: Home screen shell + habit card widget (consumes `todayDashboardProvider`)
- [x] TASK-03: Add Habit screen (boolean and numeric habits)
- [x] TASK-05: Expanded habit card — heatmap + statistics panels + circular navigation
- [ ] TASK-06: Wire navigation (GoRouter or Navigator push to remaining screens)
- [ ] TASK-07: End-to-end smoke run on emulator/device

### P1 --- Valuable if time allows

- [ ] TASK-08: History screen (scrollable dates, `getEntriesForDate`)
- [ ] TASK-09: Insights screen (weekly averages chart, completion tiles)
- [ ] TASK-10: Settings screen (navigation placeholder + export stub)
- [ ] TASK-11: Long-press selection mode → Edit/Delete
- [ ] Add one-off task support (when user is ready)

### P2 --- Defer unless already easy

- [ ] Actual notification delivery
- [ ] Remote AI backend
- [ ] Predictive modelling
- [ ] Cloud sync
- [ ] Export (CSV/JSON/XLSX)
- [ ] Nonessential animations and polish

## Known bugs / blockers

| Issue | Severity | Reproduction steps | Next action |
|---|---|---|---|
| One-off task addition skipped | MEDIUM | Intentionally deferred | Add one-off tasks when user directs |
| `go_router` unused | LOW | Grep `lib/` for `go_router` | Wire in TASK-06 |
| 37 `avoid_print` lint infos | LOW | `flutter analyze` | In test/tool files only; ignore for prototype |

## Decisions made

| Date | Decision | Reason |
|---|---|---|
| 2026-10-14 | Reset active panel to Heatmap on card reopen | Conforms with user design specification |
| 2026-10-14 | Omit trend graph for boolean habits | Trend graphs are only applicable to numeric tracking |
| 2026-10-14 | Skip one-off tasks in TASK-03 | Explicit user directive ("skip the addition of 'one-off tasks' on this step") |
| 2026-10-14 | Wire `EntryActions` directly into `HomeScreen` completion callbacks | Provides instant reactive logging feedback without waiting for TASK-04 |
| 2026-10-14 | Configure `Montserrat` as font family with platform system fallback | Avoid network downloads and font asset bundling issues during prototype sprint |
| 2026-10-14 | Preserve existing architecture entirely | Code inspection confirms it is sound and fully tested |

## Next action

**TASK-06:** Wire navigation and remaining prototype screens (History, Insights, Settings).

## Update instructions for coding agents

1. Read this file and `PROJECT_BRIEF.md` / `DESIGN.md` before changing code.
2. Change only what is needed for the assigned task.
3. Run the most relevant checks available and report their actual output/result.
4. Update this file after work, including changed files, verification performed, limitations, and next action.
5. Never claim tests passed if they were not run.
6. If a task fails, document the failure and preserve the last known working state.
7. Do not rewrite the entire file: preserve useful history and update only the relevant sections.
8. Always run `flutter analyze lib/` (not full project) to check for errors in production code after changes.
9. Run `flutter test` after any change that touches domain or data layers.
