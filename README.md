# Exercise Timer App

A Flutter-based timer application for custom workout routines.

## Features

*   **Custom Workouts:** Create and save your own workout routines with flexible sets, reps, and rest periods.
*   **Flexible Timer:** A robust timer that guides you through your workout, providing audio cues for transitions and completion.
*   **Workout History:** Keep track of your completed workouts with detailed summaries.
*   **Data Management:** Easily export your workout data to a JSON file for backup or sharing, and import data from a JSON file to restore or transfer your routines.

## Tech Stack

*   **Framework:** Flutter
*   **Database:** SQFlite - for local data persistence.
*   **State Management:** Provider - for efficient and scalable state management.
*   **Audio Playback:** `audioplayers` - for workout cues and completion sounds.
*   **File Operations:** `path_provider` and `file_picker` - for handling local file paths and user-selected files for import/export.
*   **JSON Serialization:** `json_serializable` - for converting data models to and from JSON.

## Getting Started

To run this project locally, ensure you have Flutter installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/AmitTzah/exercise_timer_app.git
    cd exercise_timer_app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.
