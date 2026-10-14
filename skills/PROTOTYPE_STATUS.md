# Overman_V0 --- Prototype Status

> This file is the source of truth for prototype progress. Update it
> after each implementation task. Record observed results, not
> intentions. Never mark something as tested unless the relevant command
> or app flow was actually run.

## Current milestone

**Target:** Working multi-screen prototype for the October 16 college
presentation.

## Current status

- Overall: Backend ready; TASK-01 (theme & tokens), TASK-02 (Home screen & habit card), and TASK-03 (Add Habit screen for boolean & numeric habits) complete.
- Last updated: 2026-10-14 02:40 IST
- Current branch/commit: `overman` / `d4d8578`
- Target device/emulator: Windows desktop & Android compact frame (412×917)
- App launches: ✅ Verified via widget testing and app compilation (`HomeScreen` and `AddHabitScreen` active)

## Working features

- [x] Local persistence across app restart (ObjectBox on `getApplicationDocumentsDirectory()`)
- [x] Dark design system tokens & application theme (`AppColors`, `AppTheme.darkTheme`)
- [x] Home screen layout
- [x] Home navigation (navigation from Home to Add screen and back)
- [x] Add habit (boolean and numeric habit creation form with schedules, units, targets, colors, and icons)
- [ ] Add one-off task (intentionally skipped per user directive; deferred to a later step)
- [x] Checkmark completion (implemented via reactive `EntryActions.logEntry/deleteEntry` in `HomeScreen`)
- [x] Numeric value logging (implemented via bottom sheet in `HomeScreen`)
- [ ] Expanded habit card
- [ ] Heatmap panel
- [ ] Statistics panel
- [ ] Numeric graph panel
- [ ] Circular swipe/arrow navigation
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

**Task ID:** TASK-03 — Add Habit screen (Boolean & Numeric habits)
- Implemented:
  - Created `lib/presentation/screens/add/add_habit_screen.dart`:
    - Form with habit name input and validation.
    - Tracking type selector: Checkmark (boolean) vs Numeric (number).
    - Numeric fields: Target value and unit (only shown when Numeric is selected).
    - Schedule selector: Daily, Specific days (weekday chips M-S), and Times per week counter.
    - Color accent palette picker (brand blue, orange, emerald, purple, pink, amber, sky blue).
    - Icon picker with relevant productivity and habit icons.
    - Persistent creation using `HabitRepository.createHabit()` which saves to ObjectBox and assigns a lifetime schedule.
    - Invalidation of `todayDashboardProvider` and `habitListProvider` upon creation for immediate reactive home updates.
    - Skipped one-off task addition per user instruction ("skip the addition of 'one-off tasks' on this step. continue with the rest. I will deal with that later").
  - Updated `lib/presentation/screens/home/home_screen.dart`:
    - Wired the orange Add button (`+`) in the header row to push `AddHabitScreen`.
    - Adjusted header button height (88px per DESIGN.md) and padding to prevent render flex overflow across device dimensions.
  - Updated `test/widget_test.dart`:
    - Added tests for navigating to `AddHabitScreen` and back to `HomeScreen`.
    - Added tests for form validation (empty name check) and dynamic display of numeric target/unit fields.
- Files changed:
  - `lib/presentation/screens/add/add_habit_screen.dart` (new)
  - `lib/presentation/screens/home/home_screen.dart` (modified)
  - `test/widget_test.dart` (modified)
- Tests/checks run:
  - `flutter analyze lib/` → ✅ `No issues found! (ran in 7.8s)`
  - `flutter test` → ✅ `All tests passed! (72/72 passed)`
- Observed result:
  - Zero analysis issues in `lib/`.
  - All 72 tests pass across data, domain, repository, and widget suites.
- Known limitations:
  - One-off tasks omitted from Add screen as requested.

## Current task

**Task ID:** TASK-05 — Expanded habit card with heatmap and statistics panels
- Goal: Implement in-place card expansion or detailed panel sequence on habit card tap:
  - Circular navigation controls.
  - Heatmap grid panel based on `StreakEngine` heatmap results.
  - Statistics panel displaying current streak, longest streak, completion rate, and best value.
  - Numeric habit graph (if numeric).
- Acceptance criteria:
  - Tapping a card expands it in place (or opens detail panel).
  - Shows heatmap first by default; circular sequence: Heatmap → Statistics → Details → Heatmap.
  - `flutter analyze lib/` reports 0 issues.
- Files likely to change:
  - `lib/presentation/widgets/habit_card.dart`
  - `lib/presentation/widgets/expanded_habit_panel.dart` (new)
  - `lib/presentation/widgets/heatmap_grid.dart` (new)

## Remaining work --- ordered by priority

### P0 --- Required for demonstration

- [x] TASK-01: Design tokens + app theme (`app_theme.dart`)
- [x] TASK-02: Home screen shell + habit card widget (consumes `todayDashboardProvider`)
- [x] TASK-03: Add Habit screen (boolean and numeric habits)
- [ ] TASK-05: Expanded habit card — heatmap + statistics panels + circular navigation
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
| 2026-10-14 | Skip one-off tasks in TASK-03 | Explicit user directive ("skip the addition of 'one-off tasks' on this step") |
| 2026-10-14 | Wire `EntryActions` directly into `HomeScreen` completion callbacks | Provides instant reactive logging feedback without waiting for TASK-04 |
| 2026-10-14 | Configure `Montserrat` as font family with platform system fallback | Avoid network downloads and font asset bundling issues during prototype sprint |
| 2026-10-14 | Preserve existing architecture entirely | Code inspection confirms it is sound and fully tested |

## Next action

**TASK-05:** Implement the expanded habit interaction with heatmap grid and statistics panels.

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
