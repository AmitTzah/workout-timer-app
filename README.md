# Exercise Timer App

A personal Android exercise timer app designed to manage sequential and alternating workouts within fixed time intervals. The app also stores workout summaries and allows users to set and track fitness goals.

## Core Functionality

### I. Workout Management & Timer Module

*   **Home Screen:**
    *   Displays a list of user-defined workouts.
    *   For each workout, users can:
        *   **Play Workout:** Initiates the timer for the selected workout.
            *   **Alternate Sets Checkbox:** Toggles between sequential and alternating set progression for the current session.
            *   **Workout Level Selection:** Choose a difficulty level from 1 to 10. Level 1 uses the base sets/times defined in the workout. Levels 2-10 increase the number of sets (for sequential) or work times (for alternating) by a percentage. The adjusted total set count for sequential workouts is **rounded up** after the percentage increase, ensuring a distinct progression. For alternating workouts, work times increase and rest times decrease proportionally.
            *   **Survival Mode:** An option to start an endless workout session. The timer counts up, and the program repeats itself endlessly, challenging the user to survive the longest.
        *   **Edit Workout:** Navigates to the Define Workout Screen to modify the workout.
        *   **Delete Workout:** Removes the workout after confirmation.
    *   Action: Floating action button to "Define New Workout".

*   **Define Workout Screen:**
    *   Users can create new workouts or edit existing ones.
    *   Input fields for:
        *   Workout Name.
        *   **Workout Type Selection (Sequential vs. Alternating):** Users choose how exercises are structured.
        *   **For Sequential Workouts:**
            *   List of exercises (users select from a predefined list of exercise names, each with number of sets, and optional number of reps).
            *   Set Interval Time (seconds) between sets.
            *   Ability to add Rest Blocks between exercises.
        *   **For Alternating Workouts:**
            *   **Alternating Groups:** Users define groups of exercises that will alternate.
                *   **Group Name:** Customizable name for each alternating group (e.g., "Warm-up," "Leg Day Finisher").
                *   **Cycles:** Number of times the exercises within this group will be repeated.
                *   **Rest between Cycles:** Optional rest period after each cycle of exercises within the group.
                *   **Exercises within Group:** For each exercise, users define:
                    *   Exercise Name (selected from predefined list).
                    *   Work Time (seconds).
                    *   Rest Time (seconds, optional).
                    *   (Note: "Sets" and "Reps" are not applicable for exercises within alternating groups, as progression is based on cycles and time.)
            *   Ability to add Rest Blocks between alternating groups.
    *   **Reorder Items:** Users can reorder exercises (sequential) or alternating groups/rest blocks (alternating) using a drag-and-drop interface.
    *   **Edit Items:** Users can edit details of exercises or rest blocks. For alternating groups, the group name, cycles, and rest between cycles can be edited.
    *   Displays: Calculated total workout duration.
    *   Action: "Save Workout" button.
    *   **Persistence:** User-defined workouts (including exercises, sets, interval time, alternating groups, cycles, and rest blocks) are saved using `Hive`.

*   **Workout Mode:**
    *   When "Start Workout" is pressed from the Home Screen, a timer begins, cycling through the exercises/groups defined in the selected workout, adjusted by the chosen level.
    *   **Sequential Sets:** Completes all sets of one exercise before moving to the next.
    *   **Alternating Sets:** Cycles through one instance of each exercise within an alternating group before repeating for the defined number of cycles. Group rest is applied between cycles.
    *   **Workout Levels:** The intensity (sets for sequential, work/rest times for alternating) is dynamically adjusted based on the selected level (1-10), ensuring a strictly increasing total workout duration across levels.
    *   **Survival Mode:** The workout repeats indefinitely. The main timer displays elapsed time (counts up) instead of time remaining. The session ends only when the user manually presses "Finish Workout".
*   The app emits a "workout_started.wav" sound at the beginning of each workout.
*   The app emits a "Next-Set.wav" sound at the end of each interval, immediately followed by the `exercise_name.wav` sound for the upcoming exercise, signaling the end of the current interval and the immediate start of the next exercise's set.
    *   **Display during workout:**
        *   Current exercise to perform.
        *   Current set/cycle progress (e.g., "Pullups: Set 3/10" or "Alternating Group 1: Cycle 2/3, Exercise: Push-ups").
        *   Overall progress (e.g., "Total Sets: 7/30").
        *   Time counting down within the current Interval Time (or counting up in Survival Mode).
    *   **Pause Workout button:** Pauses and resumes the timer.
    *   **Stop Workout button:** Prompts a confirmation dialog. If confirmed, navigates to the new Workout Summary Display Screen. The summary will reflect the exercises actually performed up to the point of stopping and the total time elapsed.
    *   Upon natural completion of all sets (not applicable in Survival Mode):
        *   An automated voice announces "workout_complete.wav".
        *   The app navigates to the Workout Summary Display Screen.

### II. Data & Progress Module

*   **Workout Summary Display Screen:**
    *   A new screen that displays comprehensive details of a completed or ended workout, including workout name, date, total duration, workout level, set progression mode (alternating/sequential), interval time, and a detailed list of individual sets performed.
    *   Indicates if the workout was completed naturally or stopped prematurely.
    *   Provides explicit "Save Workout" and "Discard Workout" buttons.
    *   If "Save Workout" is pressed, the summary is stored using Hive.

*   **Workout Summaries Screen:**
    *   Displays a history of completed workouts in an enhanced, sortable list (newest first).
    *   Each entry shows key details (workout name, date, duration, level, mode, interval, and completion status).
    *   Users can expand each entry to view a detailed list of individual sets performed.
    *   **Ability to delete individual workout summaries via a swipe-to-delete gesture.**
    *   **Data Storage:** Workout summaries are stored using Hive.

*   **Goals Screen (Optional but desired future feature):**
    *   Allows users to define personal fitness goals (e.g., "Complete 100 pullups this month," "Workout 3 times a week").
    *   Mechanism to track progress towards these goals (manual input or potentially derived from workout summaries).
    *   Displays progress for each goal.
    *   **Data Storage:** Goals are stored using Hive.

## Key App-wide Features

*   **Configurable Workout Types:** Users can choose between sequential or alternating workout structures.
*   **Workout Levels & Survival Mode:** Dynamic adjustment of workout intensity and an endless challenge mode, with guaranteed distinct total sets/times per level.
*   **Flexible Timing:** Exercises within alternating groups can have individual work and rest times.
*   **Automated Audio Cues:** "Next-Set.wav" followed by `exercise_name.wav` for interval transitions, "workout_complete.wav" for session completion.
*   **Progress Tracking:** Displays relevant progress information for workouts and goals.
*   **Data Persistence:**
    *   User-defined Workouts, Workout Summaries & Goals: Local database (`Hive`).
*   **User Interface:** Clear, simple, and intuitive.
*   **Target Platform:** Android (version 9 or newer).
*   **Development Environment:** Flutter with VS Code.

## Getting Started

This project is a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
