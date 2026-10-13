# Overman_V0 --- Prototype Status

> This file is the source of truth for prototype progress. Update it
> after each implementation task. Record observed results, not
> intentions. Never mark something as tested unless the relevant command
> or app flow was actually run.

## Current milestone

**Target:** Working multi-screen prototype for the October 16 college
presentation.

## Current status

- Overall: Backend ready; TASK-01 (theme & tokens) complete; ready for UI screen implementation
- Last updated: 2026-10-14 02:12 IST
- Current branch/commit: `overman` / `d4d8578`
- Target device/emulator: Windows desktop & Android compact frame (412×917)
- App launches: ✅ Verified via widget testing and app theme compilation

## Working features

- [x] Local persistence across app restart (ObjectBox on `getApplicationDocumentsDirectory()`)
- [x] Dark design system tokens & application theme (`AppColors`, `AppTheme.darkTheme`)
- [ ] Home screen layout
- [ ] Home navigation
- [ ] Add habit
- [ ] Add one-off task
- [ ] Checkmark completion
- [ ] Numeric value logging
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

**Task ID:** TASK-01 — Design tokens and dark application theme
- Implemented:
  - Created `lib/presentation/theme/app_theme.dart` containing `AppColors` (with `#0F1115`, `#1C1F26`, `#216CCF`, `#FF7A45`, `#A4AFBE`, `#E7E8EA`, `#0F1115`, plus semantic aliases).
  - Created `AppTheme.darkTheme` configuring Material 3 dark `ColorScheme`, `scaffoldBackgroundColor`, `CardThemeData`, `InputDecorationTheme`, button themes (`ElevatedButtonThemeData`, `FilledButtonThemeData`, `OutlinedButtonThemeData`), typography, divider, and icon styling.
  - Configured `Montserrat` as default `fontFamily` across typography and controls, falling back cleanly to system sans-serif without introducing network or font bundling blockers.
  - Updated `lib/main.dart` to use `AppTheme.darkTheme` and `AppColors.blue`.
  - Updated `test/widget_test.dart` to assert that the dark theme and token colors are properly rendered.
- Files changed:
  - `lib/presentation/theme/app_theme.dart` (new)
  - `lib/main.dart` (modified)
  - `test/widget_test.dart` (modified)
- Tests/checks run:
  - `flutter analyze lib/` → ✅ `No issues found! (ran in 4.7s)`
  - `flutter test` → ✅ `All tests passed! (68/68 passed)`
- Observed result:
  - Zero analysis errors in `lib/`.
  - All unit, domain, repository, and widget tests pass with the dark theme applied.
- Known limitations:
  - Montserrat font family is configured with platform system fallback; custom TTF assets are not bundled in `assets/` to avoid build overhead and network dependencies during rapid prototyping.

## Current task

**Task ID:** TASK-02 — Home screen shell & habit card widget
- Goal: Create `lib/presentation/screens/home/home_screen.dart` and `lib/presentation/widgets/habit_card.dart` consuming `todayDashboardProvider`.
- Acceptance criteria:
  - Header row displays selected date (`23 Sep`), progress counter (`0 / 2`), stub buttons for History, Add, Settings.
  - Habit cards render name, status accent, completion control (checkmark / dash / numeric value & unit).
  - Listens to `todayDashboardProvider` reactively.
  - `flutter analyze lib/` passes with 0 issues.
- Files likely to change:
  - `lib/presentation/screens/home/home_screen.dart` (new)
  - `lib/presentation/widgets/habit_card.dart` (new)
  - `lib/main.dart` (point `home:` to `HomeScreen`)

## Remaining work --- ordered by priority

### P0 --- Required for demonstration

- [x] TASK-01: Design tokens + app theme (`app_theme.dart`)
- [ ] TASK-02: Home screen shell + habit card widget (consumes `todayDashboardProvider`)
- [ ] TASK-03: Add Habit/Task screen (form → `habitRepository.createHabit()`)
- [ ] TASK-04: Completion interaction (boolean tap + numeric bottom sheet → `EntryActions.logEntry()`)
- [ ] TASK-05: Expanded habit card — heatmap + statistics panels + circular navigation
- [ ] TASK-06: Wire navigation (GoRouter or Navigator push)
- [ ] TASK-07: End-to-end smoke run on emulator/device

### P1 --- Valuable if time allows

- [ ] TASK-08: History screen (scrollable dates, `getEntriesForDate`)
- [ ] TASK-09: Insights screen (weekly averages chart, completion tiles)
- [ ] TASK-10: Settings screen (navigation placeholder + export stub)
- [ ] TASK-11: Long-press selection mode → Edit/Delete

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
| No UI screens implemented yet | HIGH | Launch app | Begin TASK-02 (Home screen) |
| No task concept in domain | HIGH | Inspect `HabitType` enum | Add `isOneOff` flag to `HabitDto`+`HabitEntity` with ObjectBox migration in TASK-03 |
| `go_router` unused | MEDIUM | Grep `lib/` for `go_router` | Wire in TASK-06 |
| 37 `avoid_print` lint infos | LOW | `flutter analyze` | In test/tool files only; ignore for prototype |

## Decisions made

| Date | Decision | Reason |
|---|---|---|
| 2026-10-14 | Configure `Montserrat` as font family with platform system fallback | Avoid network downloads and font asset bundling issues during prototype sprint |
| 2026-10-14 | Preserve existing architecture entirely | Code inspection confirms it is sound and fully tested |
| 2026-10-14 | Represent one-off tasks as `HabitType.boolean` + `isOneOff: bool` flag | Avoids new domain concept; schedule `effectiveTo = createdAt+1day` prevents future recurrence |

## Next action

**TASK-02:** Create `HomeScreen` and `HabitCard` widget consuming `todayDashboardProvider`, replacing the placeholder screen in `main.dart`.

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
