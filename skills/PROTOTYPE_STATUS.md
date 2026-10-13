# Overman_V0 --- Prototype Status

> This file is the source of truth for prototype progress. Update it
> after each implementation task. Record observed results, not
> intentions. Never mark something as tested unless the relevant command
> or app flow was actually run.

## Current milestone

**Target:** Working multi-screen prototype for the October 16 college
presentation.

## Current status

- Overall: Backend ready; TASK-01 (theme & tokens) and TASK-02 (Home screen & habit card) complete; ready for Add Habit/Task screen
- Last updated: 2026-10-14 02:27 IST
- Current branch/commit: `overman` / `d4d8578`
- Target device/emulator: Windows desktop & Android compact frame (412×917)
- App launches: ✅ Verified via widget testing and app compilation (`HomeScreen` active)

## Working features

- [x] Local persistence across app restart (ObjectBox on `getApplicationDocumentsDirectory()`)
- [x] Dark design system tokens & application theme (`AppColors`, `AppTheme.darkTheme`)
- [x] Home screen layout
- [ ] Home navigation
- [ ] Add habit
- [ ] Add one-off task
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

**Task ID:** TASK-02 — Home screen shell & habit card widget
- Implemented:
  - Created `lib/presentation/widgets/habit_card.dart` adhering to DESIGN.md (~375×109 layout):
    - Rounded surface container with narrow left-edge status accent (blue for met/exceeded, muted grey otherwise).
    - Habit title, schedule/target metadata, and streak indicator (`🔥 X days`) when streak > 0.
    - Square completion control on right with checkmark for boolean habits and logged value + unit for numeric habits.
    - Accessible semantic labels and tap callbacks (`onTap`, `onCompletionTap`, `onLongPress`).
  - Created `lib/presentation/screens/home/home_screen.dart`:
    - Responsive header action row with Date/History button (e.g. `14 Oct`, `0 / X completed`), orange Add button (`+`), and Settings button (`⚙`).
    - Reactive consumption of `todayDashboardProvider` with loading, error/retry, and empty states.
    - Interactive completion handler: toggles boolean completion via `entryActionsProvider` and launches numeric modal sheet for number logging.
  - Updated `lib/main.dart` replacing the static placeholder with `const HomeScreen()`.
  - Updated `test/widget_test.dart` with tests for `HomeScreen`, boolean `HabitCard` toggle, and numeric `HabitCard` rendering.
- Files changed:
  - `lib/presentation/widgets/habit_card.dart` (new)
  - `lib/presentation/screens/home/home_screen.dart` (new)
  - `lib/main.dart` (modified)
  - `test/widget_test.dart` (modified)
- Tests/checks run:
  - `flutter analyze lib/` → ✅ `No issues found! (ran in 6.4s)`
  - `flutter test` → ✅ `All tests passed! (70/70 passed)`
- Observed result:
  - Zero analysis issues in `lib/`.
  - All 70 tests pass across domain, data, and presentation layers.
- Known limitations:
  - Header buttons currently display SnackBar stubs pending navigation integration in TASK-03, TASK-06, and TASK-08.

## Current task

**Task ID:** TASK-03 — Add Habit/Task screen & form
- Goal: Create `lib/presentation/screens/add/add_habit_screen.dart` allowing creation of boolean habits, numeric habits, and one-off tasks via `habitRepository.createHabit()`.
- Acceptance criteria:
  - Form fields for name, type (boolean/numeric), unit/target (if numeric), schedule selection (daily default).
  - One-off task toggle.
  - Wire Add button on `HomeScreen` to push `AddHabitScreen`.
  - Successful save adds item to ObjectBox database and navigates back to `HomeScreen`, triggering reactive UI update.
  - `flutter analyze lib/` passes with 0 issues.
- Files likely to change:
  - `lib/presentation/screens/add/add_habit_screen.dart` (new)
  - `lib/presentation/screens/home/home_screen.dart` (wire Add button navigation)

## Remaining work --- ordered by priority

### P0 --- Required for demonstration

- [x] TASK-01: Design tokens + app theme (`app_theme.dart`)
- [x] TASK-02: Home screen shell + habit card widget (consumes `todayDashboardProvider`)
- [ ] TASK-03: Add Habit/Task screen (form → `habitRepository.createHabit()`)
- [ ] TASK-04: Refine completion interaction & numeric input validation
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
| Add button currently triggers stub SnackBar | MEDIUM | Tap orange + on HomeScreen | Implement `AddHabitScreen` in TASK-03 |
| One-off task domain representation | MEDIUM | Add task flow | Model one-off task with effectiveTo boundary in TASK-03 |
| `go_router` unused | LOW | Grep `lib/` for `go_router` | Wire in TASK-06 |
| 37 `avoid_print` lint infos | LOW | `flutter analyze` | In test/tool files only; ignore for prototype |

## Decisions made

| Date | Decision | Reason |
|---|---|---|
| 2026-10-14 | Wire `EntryActions` directly into `HomeScreen` completion callbacks | Provides instant reactive logging feedback without waiting for TASK-04 |
| 2026-10-14 | Configure `Montserrat` as font family with platform system fallback | Avoid network downloads and font asset bundling issues during prototype sprint |
| 2026-10-14 | Preserve existing architecture entirely | Code inspection confirms it is sound and fully tested |
| 2026-10-14 | Represent one-off tasks as `HabitType.boolean` + `isOneOff: bool` flag | Avoids new domain concept; schedule `effectiveTo = createdAt+1day` prevents future recurrence |

## Next action

**TASK-03:** Create `lib/presentation/screens/add/add_habit_screen.dart` and wire the orange Add button on `HomeScreen` to navigate to it.

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
