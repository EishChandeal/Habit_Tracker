1. Habit Management (CRUD & Archiving)
2. Flexible Habit Types (Checkmark vs. Measurable)
3. History-Aware Scheduling (Daily, Weekdays, timesPerWeek, timesPerMonth)
4. Reconstructive Streak Engine
5. Statistics and Trends
6. Day Rollover & App Lifecycle Listener
7. Dashboard State Organizer

- saved UI and specific user profiles (auth, registeration, login) for later

**Phase Organization**

**Phase 1: Core Habit Logging** (The "one-tap" experience)

- Main today view
- Quick habit completion toggle
- Visual feedback/satisfaction animations

**Phase 2: Habit Management**

- CRUD operations for habits
- Target setting interface
- Scheduling/frequency configuration

**Phase 3: Streaks & Progress**

- Streak visualization
- History/calendar view
- Statistics dashboard

**Phase 4: Polishing & Edge Cases**

- Empty states
- Error handling UI
- Responsive adaptations
- Micro-interactions

# The prompt

# My goal :

I am vibe coding, developing a high quality mobile application, a habit tracking app that will be built using flutter/dart, the core principle around which it will be built: "make it easy, make it visible, make it satisfying, make it attractive" for the user using it.

## What I want you to do:

I will give you wireframes, rough drawings per screen after the initial well designed images I have with me on how I want the app's screens to look like. You will create high quality prompts, that AI agent can understand easily and design the UI effectively. Below I have written in further detail How we will work

### 1. I have created a single `UI_DEVELOPMENT_PLAN.md` that serves as both product doc and prompt repository. It is structured like this:

```markdown
# UI Development Plan - V1

## Overview

- Core principle: Minimum friction, one-tap interactions
- Tech stack: Flutter, Riverpod, Clean Architecture
- Design language: [Brief note about your wireframes/style]

## Phase Structure

Each phase = one complete, testable feature
```

### 2. **Our Collaboration Process**

For each feature, I suggest this flow:

**Step A: I will explain the feature**

- What the user needs to accomplish
- The flow (screen to screen)
- Any specific interactions (swipe, tap, long press)
- Wireframes/screenshots for reference

**Step B: You translate it into a structured prompt**

- Clear UI specifications
- Widget hierarchy
- State management connections (which Riverpod providers to use)
- Edge cases and loading states
- Acceptance criteria for testing

**Step C: I review, and we refine**

- I check if your interpretation matches my vision
- We iterate until the prompt is precise

# What I have already vibe coded (The backend portion)

I have vibe coded and tested the backend logic, The project is built using Clean Architecture (Domain, Data, Application, and Presentation layers) with ObjectBox for local persistence and Riverpod for state management.

At this stage, the backend is complete, and the presentation layer is a placeholder. The following features have their backend, data models, database schemas, and Riverpod state providers fully implemented, requiring only the frontend/UI integration to be operational:the features include:

1. Habit Management (CRUD & Archiving)
2. Flexible Habit Types (Checkmark vs. Measurable)
3. History-Aware Scheduling (Daily, Weekdays, timesPerWeek, timesPerMonth)
4. Reconstructive Streak Engine
5. Statistics and Trends
6. Day Rollover & App Lifecycle Listener
7. Dashboard State Organizer

# so shall we get started?
