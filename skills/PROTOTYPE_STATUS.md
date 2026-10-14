# Overman_V0 --- Prototype Status

> This file is the source of truth for prototype progress. Update it
> after each implementation task. Record observed results, not
> intentions. Never mark something as tested unless the relevant command
> or app flow was actually run.

## Current milestone

**Target:** Working multi-screen prototype for the October 16 college
presentation.

## Current status

- Overall: Backend ready; TASK-01 (theme & tokens), TASK-02 (Home screen & habit card), TASK-03 (Add Habit screen), TASK-05 (expanded habit card with circular panels), and TASK-06 (wired navigation, History, Insights, and Settings screens) complete.
- Last updated: 2026-10-14 09:55 IST
- Current branch/commit: `overman` / `d4d8578`
- Target device/emulator: Windows desktop & Android compact frame (412×917)
- App launches: ✅ Verified via widget testing and app compilation (`HomeScreen`, `AddHabitScreen`, `HistoryScreen`, `InsightsScreen`, and `SettingsScreen` active)

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
- [x] History screen (scrollable 30-day past calendar strip, per-date entries, and interactive historical logging)
- [x] Insights screen (high-level metrics overview, weekly activity chart, and per-habit performance bars)
- [x] Settings screen (navigation shortcuts, prototype export triggers, preferences, and about card)
- [x] CSV export (prototype UI trigger with feedback)
- [x] JSON export (prototype UI trigger with feedback)
- [x] XLSX export (prototype UI trigger with feedback)
- [ ] Final demonstration walkthrough

## Latest completed task

**Task ID:** TASK-06 — Wire navigation and remaining prototype screens (History, Insights, Settings)
- Implemented:
  - Created `lib/presentation/navigation/app_router.dart`:
    - Defined central `AppRoutes` (`/`, `/add`, `/history`, `/insights`, `/settings`).
    - Configured declarative `GoRouter` instance (`appRouter`).
    - Added `appNavigateTo` helper ensuring compatibility with both GoRouter and standalone Navigator tests.
  - Created `lib/presentation/screens/history/history_screen.dart`:
    - 30-day horizontal date strip in reverse chronological order (Today, Yesterday, ...).
    - Summary banner showing recorded habits count for the selected date.
    - Habit list with reactive entry states (completed checkmark vs not logged, numeric logged vs target).
    - Interactive entry logging/editing on past dates via `EntryActions` (boolean toggle and numeric bottom sheet).
    - Header shortcut button directly to InsightsScreen.
  - Created `lib/presentation/screens/insights/insights_screen.dart`:
    - High-level metric cards: Active Habits, Data Engine, Target Frame, Status.
    - Weekly activity chart displaying the current 7-day Monday–Sunday timeline.
    - Per-habit breakdown list showing streaks, completion percentage, and linear progress bars.
  - Created `lib/presentation/screens/settings/settings_screen.dart`:
    - Navigation shortcuts to Insights, History, and Add Habit.
    - Prototype export actions (CSV, JSON, XLSX) with feedback snackbars.
    - Preferences summary (Dark theme, Monday first day, Midnight day-change reset).
    - About card detailing Overman_V0 prototype specs and target frame.
  - Updated `lib/presentation/screens/home/home_screen.dart`:
    - Wired History / Date button in header to push `HistoryScreen`.
    - Wired Add button in header to push `AddHabitScreen`.
    - Wired Settings button in header to push `SettingsScreen`.
  - Updated `lib/main.dart`:
    - Switched `MaterialApp` to `MaterialApp.router` using `appRouter`.
  - Updated `test/widget_test.dart`:
    - Added tests for navigating to `HistoryScreen` and back.
    - Added tests for navigating to `SettingsScreen`, triggering export, visiting `InsightsScreen`, and popping back.
    - Added test for opening `InsightsScreen` from `HistoryScreen` header action.
- Files changed:
  - `lib/presentation/navigation/app_router.dart` (new)
  - `lib/presentation/screens/history/history_screen.dart` (new)
  - `lib/presentation/screens/insights/insights_screen.dart` (new)
  - `lib/presentation/screens/settings/settings_screen.dart` (new)
  - `lib/presentation/screens/home/home_screen.dart` (modified)
  - `lib/main.dart` (modified)
  - `test/widget_test.dart` (modified)
- Tests/checks run:
  - `flutter analyze lib/` → ✅ `No issues found! (ran in 9.2s)`
  - `flutter test` → ✅ `All tests passed! (77/77 passed)`
- Observed result:
  - Zero analysis issues in `lib/`.
  - All 77 tests pass across data, domain, repository, and widget suites.
- Known limitations:
  - One-off tasks omitted from Add screen as previously requested.

## Current task

**Task ID:** TASK-07 — End-to-end smoke run and demonstration verification
- Goal: Perform end-to-end smoke verification on target frame and verify full demonstration flow.
- Acceptance criteria:
  - All screens navigate seamlessly.
  - `flutter analyze lib/` reports 0 issues.
  - `flutter test` passes.

## Remaining work --- ordered by priority

### P0 --- Required for demonstration

- [x] TASK-01: Design tokens + app theme (`app_theme.dart`)
- [x] TASK-02: Home screen shell + habit card widget (consumes `todayDashboardProvider`)
- [x] TASK-03: Add Habit screen (boolean and numeric habits)
- [x] TASK-05: Expanded habit card — heatmap + statistics panels + circular navigation
- [x] TASK-06: Wire navigation (GoRouter & Navigator push to History, Insights, Settings)
- [ ] TASK-07: End-to-end smoke run on emulator/device

### P1 --- Valuable if time allows

- [x] TASK-08: History screen (scrollable dates, `getEntriesForDate` completed in TASK-06)
- [x] TASK-09: Insights screen (weekly activity chart, completion tiles completed in TASK-06)
- [x] TASK-10: Settings screen (navigation shortcuts + export stubs completed in TASK-06)
- [ ] TASK-11: Long-press selection mode → Edit/Delete
- [ ] Add one-off task support (when user is ready)

### P2 --- Defer unless already easy

- [ ] Actual notification delivery
- [ ] Remote AI backend
- [ ] Predictive modelling
- [ ] Cloud sync
- [ ] Nonessential animations and polish

## Known bugs / blockers

| Issue | Severity | Reproduction steps | Next action |
|---|---|---|---|
| One-off task addition skipped | MEDIUM | Intentionally deferred | Add one-off tasks when user directs |
| 37 `avoid_print` lint infos | LOW | `flutter analyze` | In test/tool files only; ignore for prototype |

## Decisions made

| Date | Decision | Reason |
|---|---|---|
| 2026-10-14 | Implement GoRouter with fallback helper | Allows declarative routing while keeping widget test suites completely robust |
| 2026-10-14 | Reset active panel to Heatmap on card reopen | Conforms with user design specification |
| 2026-10-14 | Omit trend graph for boolean habits | Trend graphs are only applicable to numeric tracking |
| 2026-10-14 | Skip one-off tasks in TASK-03 | Explicit user directive ("skip the addition of 'one-off tasks' on this step") |
| 2026-10-14 | Wire `EntryActions` directly into `HomeScreen` completion callbacks | Provides instant reactive logging feedback without waiting for TASK-04 |
| 2026-10-14 | Configure `Montserrat` as font family with platform system fallback | Avoid network downloads and font asset bundling issues during prototype sprint |
| 2026-10-14 | Preserve existing architecture entirely | Code inspection confirms it is sound and fully tested |

## Next action

**TASK-07:** End-to-end smoke run on emulator/device and presentation walkthrough.

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
