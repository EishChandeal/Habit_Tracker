# Overman_V0 --- Prototype Status

> This file is the source of truth for prototype progress. Update it
> after each implementation task. Record observed results, not
> intentions. Never mark something as tested unless the relevant command
> or app flow was actually run.

## Current milestone

**Target:** Working multi-screen prototype

## Current status

- Overall: Backend ready; TASK-01 through TASK-06 complete; user verified Windows desktop smoke test passed; TASK-11 (Selection mode, Edit, and Delete functionality) complete.
- Last updated: 2026-10-14 10:40 IST
- Current branch/commit: `overman` / `d4d8578`
- Target device/emulator: Windows desktop & Android compact frame (412×917)
- App launches: Verified on Windows desktop by user & verified via widget tests (81/81 tests passing)

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
- [x] Selection mode (long-press to enter selection mode with orange card highlight, deselect on tap outside or close icon)
- [x] Edit habit (prepopulates name, type, unit, target value, color, icon, and schedule; persists updates via repository)
- [x] Delete habit with confirmation (AlertDialog confirmation; cascades deletion across entries, schedules, limits; reactive refresh)
- [x] Details panel action shortcuts (direct Edit and Delete buttons on expanded habit details)
- [x] History screen (scrollable 30-day past calendar strip, per-date entries, and interactive historical logging)
- [x] Insights screen (high-level metrics overview, weekly activity chart, and per-habit performance bars)
- [x] Settings screen (navigation shortcuts, prototype export triggers, preferences, and about card)
- [x] CSV export (prototype UI trigger with feedback)
- [x] JSON export (prototype UI trigger with feedback)
- [x] XLSX export (prototype UI trigger with feedback)
- [ ] Final demonstration walkthrough

## Latest completed task

**Task ID:** TASK-11 — Long-press selection mode, Edit & Delete functionality

- Implemented:
  - `lib/presentation/screens/home/home_screen.dart`:
    - Converted `HomeScreen` to `ConsumerStatefulWidget` maintaining selection state (`_selectedHabitStatus`).
    - Added `_buildSelectionHeaderRow`: transforms top header (height 88) into Deselect / Selected Habit Info (`1 selected`), Edit action, and Delete action buttons.
    - Wrapped layout in `GestureDetector(behavior: HitTestBehavior.translucent)` so tapping outside cards exits selection mode cleanly.
    - Tapping close icon or selected info card exits selection mode.
    - Implemented `_confirmDelete`: displays `AlertDialog` with red Delete confirmation action; permanently removes habit and cascades deletions across entries, schedules, and limits via `HabitRepository.deleteHabit`; invalidates providers and clears selection.
    - Implemented `_editHabit`: opens `AddHabitScreen` with pre-filled habit and active schedule; clears selection upon return.
  - `lib/presentation/screens/add/add_habit_screen.dart`:
    - Added `habitToEdit` and `scheduleToEdit` parameters to constructor.
    - Prepopulates name, habit type, unit, target value, color hex, icon name, and schedule settings in `initState`.
    - Updates `_saveHabit()` to branch between creation (`createHabit`) and editing (`updateHabit` and `setSchedule`).
    - Displays dynamic title ("Edit Habit" vs "New Habit") and submit label ("Save Changes" vs "Create Habit").
  - `lib/presentation/widgets/habit_card.dart`:
    - Added `isSelected`, `onEdit`, `onDelete` properties.
    - Highlights selected card with orange border (`side: BorderSide(color: AppColors.orange, width: 2)`).
    - Forwards `onEdit` and `onDelete` to `DetailsPanel`.
  - `lib/presentation/widgets/details_panel.dart`:
    - Added direct "Edit" and "Delete" OutlinedButtons in expanded habit details panel for direct action without entering selection mode.
  - `test/widget_test.dart`:
    - Added test for entering selection mode on long-press and exiting via cancel.
    - Added test for edit flow: prepopulating form, editing name, saving, and verifying updated name on home screen.
    - Added test for delete flow: confirmation dialog, deleting habit, verifying removal and snackbar notification.
    - Added test for direct Edit and Delete buttons on expanded habit `DetailsPanel`.
- Files changed:
  - `lib/presentation/screens/home/home_screen.dart` (modified)
  - `lib/presentation/screens/add/add_habit_screen.dart` (modified)
  - `lib/presentation/widgets/habit_card.dart` (modified)
  - `lib/presentation/widgets/details_panel.dart` (modified)
  - `test/widget_test.dart` (modified)
- Tests/checks run:
  - `flutter analyze lib/` → ✅ `No issues found! (ran in 6.3s)`
  - `flutter test` → ✅ `All tests passed! (81/81 passed)`
- Observed result:
  - Zero analysis issues in `lib/`.
  - All 81 tests pass across data, domain, repository, and widget suites.
- Known limitations:
  - One-off tasks omitted from Add screen as previously requested.

## Current task

**Task ID:** TASK-12 — Prototype polish & optional one-off tasks

- Goal: Polish UI interactions and add one-off tasks when user is ready.
- Acceptance criteria:
  - Codebase remains clean with 0 analysis issues and passing tests.

## Remaining work --- ordered by priority

### P0 --- Required for demonstration

- [x] TASK-01: Design tokens + app theme (`app_theme.dart`)
- [x] TASK-02: Home screen shell + habit card widget (consumes `todayDashboardProvider`)
- [x] TASK-03: Add Habit screen (boolean and numeric habits)
- [x] TASK-05: Expanded habit card — heatmap + statistics panels + circular navigation
- [x] TASK-06: Wire navigation (GoRouter & Navigator push to History, Insights, Settings)
- [x] TASK-07: End-to-end smoke run on emulator/device (user verified Windows smoke run)
- [x] TASK-11: Long-press selection mode → Edit/Delete

### P1 --- Valuable if time allows

- [x] TASK-08: History screen (scrollable dates, `getEntriesForDate` completed in TASK-06)
- [x] TASK-09: Insights screen (weekly activity chart, completion tiles completed in TASK-06)
- [x] TASK-10: Settings screen (navigation shortcuts + export stubs completed in TASK-06)
- [ ] Add one-off task support (when user is ready)

### P2 --- Defer unless already easy

- [ ] Actual notification delivery
- [ ] Remote AI backend
- [ ] Predictive modelling
- [ ] Cloud sync
- [ ] Nonessential animations and polish

## Known bugs / blockers

| Issue                         | Severity | Reproduction steps     | Next action                                   |
| ----------------------------- | -------- | ---------------------- | --------------------------------------------- |
| One-off task addition skipped | MEDIUM   | Intentionally deferred | Add one-off tasks when user directs           |
| 37 `avoid_print` lint infos   | LOW      | `flutter analyze`      | In test/tool files only; ignore for prototype |

## Decisions made

| Date       | Decision                                                            | Reason                                                                         |
| ---------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| 2026-10-14 | Implement GoRouter with fallback helper                             | Allows declarative routing while keeping widget test suites completely robust  |
| 2026-10-14 | Reset active panel to Heatmap on card reopen                        | Conforms with user design specification                                        |
| 2026-10-14 | Omit trend graph for boolean habits                                 | Trend graphs are only applicable to numeric tracking                           |
| 2026-10-14 | Skip one-off tasks in TASK-03                                       | Explicit user directive ("skip the addition of 'one-off tasks' on this step")  |
| 2026-10-14 | Wire `EntryActions` directly into `HomeScreen` completion callbacks | Provides instant reactive logging feedback without waiting for TASK-04         |
| 2026-10-14 | Configure `Montserrat` as font family with platform system fallback | Avoid network downloads and font asset bundling issues during prototype sprint |
| 2026-10-14 | Preserve existing architecture entirely                             | Code inspection confirms it is sound and fully tested                          |

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
