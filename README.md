# habit_tracker

A Flutter-based habit tracking app built for daily use, designed around one core principle: the least friction possible between a user and their data. Every interaction — logging a habit, reviewing a streak, adjusting a target — should take one tap at best, and feel satisfying to do. The experience at each entry point is treated as a product decision, not just a UI detail.
The app supports numeric and boolean habit types, flexible scheduling (daily, specific weekdays, or a set number of times per week or month), per-habit limits with full history, streak tracking, calendar heatmaps, and statistics. Data is fully portable — users own it and can move it in or out freely.
Currently in backend development. The foundation being built is a clean, layered Dart architecture — ObjectBox for local persistence, Riverpod for state, pure domain services for streak and statistics logic — deliberately decoupled from any UI so that any interface built on top of it works without touching the data layer. The scheduling system is built to respect history: changing a habit's schedule takes effect from that day forward, leaving all past data evaluated under the rules that were active when it was logged.
The backend will be fully tested and verified before a single widget is written.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
