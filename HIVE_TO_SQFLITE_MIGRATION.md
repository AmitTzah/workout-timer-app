# Detailed Hive to SQFlite Migration Plan

This document outlines a 4-step migration plan to replace the Hive database with SQFlite in the application. This plan is designed for a scenario where no user data needs to be migrated. Each step is a distinct, self-contained commit.

---

## Step 1: Setup & Repository Abstraction

**Goal:** Decouple all data access logic from the UI and business logic layers by creating a formal data access contract (abstract repositories). This is the most critical step for a clean architecture.

*   **Detailed Technical Tasks:**

    1.  **Add Dependencies:**
        *   Open `pubspec.yaml`.
        *   Add the `sqflite` and `path` packages under `dependencies`.

        ```yaml
        dependencies:
          flutter:
            sdk: flutter
          # ... other dependencies
          sqflite: ^2.3.0 # Use the latest version
          path: ^1.8.3   # Use the latest version
        ```

    2.  **Define Repository Contracts:**
        *   The files `lib/repositories/user_workout_repository.dart` and `lib/repositories/workout_summary_repository.dart` will be converted into abstract classes (interfaces).
        *   In `lib/repositories/user_workout_repository.dart`, define the abstract class:

        ```dart
        // lib/repositories/user_workout_repository.dart
        import '../models/user_workout.dart';

        abstract class UserWorkoutRepository {
          Future<List<UserWorkout>> getAllWorkouts();
          Future<UserWorkout?> getWorkoutById(String id);
          Future<void> saveWorkout(UserWorkout workout);
          Future<void> deleteWorkout(String id);
        }
        ```
        *   Do the same for `lib/repositories/workout_summary_repository.dart`, paying special attention to replacing the Hive-specific `ValueListenable<Box<...>>` with a generic `Stream`.

    3.  **Create Hive Implementations:**
        *   Create a new directory: `lib/repositories/hive/`.
        *   Create `lib/repositories/hive/hive_user_workout_repository_impl.dart`.
        *   Move all the original Hive logic from the old `user_workout_repository.dart` into this new file. Make the class implement the abstract repository.

        ```dart
        // lib/repositories/hive/hive_user_workout_repository_impl.dart
        import 'package:hive/hive.dart';
        import '../user_workout_repository.dart';
        import '../../models/user_workout.dart';

        class HiveUserWorkoutRepositoryImpl implements UserWorkoutRepository {
          final Box<UserWorkout> _workoutBox;

          HiveUserWorkoutRepositoryImpl(this._workoutBox);

          @override
          Future<void> saveWorkout(UserWorkout workout) async {
            await _workoutBox.put(workout.id, workout);
          }

          // ... implement all other methods using _workoutBox
        }
        ```
        *   Repeat this process for the workout summaries, creating a `HiveWorkoutSummaryRepositoryImpl`.

    4.  **Update Dependency Injection (DI):**
        *   Locate your DI setup (likely in `lib/main.dart` or a dedicated file).
        *   Ensure that wherever you were providing the concrete Hive logic before, you are now providing the `HiveUserWorkoutRepositoryImpl` but typed as the abstract `UserWorkoutRepository`.

        ```dart
        // Example using Provider in lib/main.dart
        MultiProvider(
          providers: [
            Provider<UserWorkoutRepository>(
              create: (_) => HiveUserWorkoutRepositoryImpl(
                Hive.box('user_workouts'),
              ),
            ),
            // ... other providers
          ],
          child: const MyApp(),
        ),
        ```

*   **Git Commit Message:**
    ```
    feat(db): introduce repository abstraction for data access

    - Add sqflite and path dependencies.
    - Convert repository classes into abstract contracts to decouple the data layer.
    - Move existing Hive logic into concrete `Hive...Impl` classes.
    - Update DI to provide the Hive implementations via the new abstract types.

    This change prepares the codebase for the SQFlite implementation without altering functionality.
    ```

---

## Step 2: Implement Full SQFlite Persistence Layer

**Goal:** Build the entire SQFlite data layer in parallel with the existing (but now abstracted) Hive layer.

*   **Detailed Technical Tasks:**

    1.  **Add Model Serialization:**
        *   Open model files like `lib/models/user_workout.dart`.
        *   Ensure they have `toJson` and `factory fromJson` methods, likely using `json_serializable`.
        *   For nested objects (e.g., `List<Exercise>` within `UserWorkout`), you will need a `JsonConverter` to store them as a single JSON string in the database.
        *   Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate the serialization code.

    2.  **Create SQFlite Service:**
        *   Create `lib/services/sqflite_database_service.dart`.
        *   Implement the initialization logic and table creation.

        ```dart
        // lib/services/sqflite_database_service.dart
        import 'package:sqflite/sqflite.dart';
        import 'package:path/path.dart';

        class SqfliteDatabaseService {
          Database? _database;

          Future<Database> get database async {
            if (_database != null) return _database!;
            _database = await _initDB();
            return _database!;
          }

          Future<Database> _initDB() async {
            final dbPath = await getDatabasesPath();
            final path = join(dbPath, 'workouts.db');
            return await openDatabase(path, version: 1, onCreate: _onCreate);
          }

          Future<void> _onCreate(Database db, int version) async {
            await db.execute('''
              CREATE TABLE user_workouts (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                items TEXT NOT NULL, -- Storing the list of exercises as a JSON string
                // ... other columns
              )
            ''');
            // ... CREATE TABLE for workout_summaries
          }
        }
        ```

    3.  **Create SQFlite Implementations:**
        *   Create a new directory: `lib/repositories/sqflite/`.
        *   Create `lib/repositories/sqflite/sqflite_user_workout_repository_impl.dart`.
        *   Implement the repository interface using the `SqfliteDatabaseService`.

        ```dart
        // lib/repositories/sqflite/sqflite_user_workout_repository_impl.dart
        import '../../models/user_workout.dart';
        import '../user_workout_repository.dart';
        import '../../services/sqflite_database_service.dart';

        class SqfliteUserWorkoutRepositoryImpl implements UserWorkoutRepository {
          final SqfliteDatabaseService _dbService;

          SqfliteUserWorkoutRepositoryImpl(this._dbService);

          @override
          Future<void> saveWorkout(UserWorkout workout) async {
            final db = await _dbService.database;
            await db.insert(
              'user_workouts',
              workout.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          // ... implement all other methods
        }
        ```
        *   Repeat for `SqfliteWorkoutSummaryRepositoryImpl`.

*   **Git Commit Message:**
    ```
    feat(db): implement complete SQFlite persistence layer

    - Add json_serializable annotations and converters to data models.
    - Create SqfliteDatabaseService to manage the database lifecycle and schema.
    - Build and implement Sqflite repository classes for all data types.

    The full SQFlite data layer is now complete and ready for use, existing in parallel with the Hive implementation.
    ```

---

## Step 3: Activate SQFlite Persistence Layer

**Goal:** Atomically switch the application from using the Hive implementation to the new SQFlite implementation. This is a small but critical change.

*   **Detailed Technical Tasks:**

    1.  **Update Dependency Injection:**
        *   Go back to your DI setup (e.g., in `lib/main.dart`).
        *   Change the class being created in the provider from the `Hive...Impl` to the `Sqflite...Impl`.

        ```dart
        // Example using Provider in lib/main.dart
        final sqfliteService = SqfliteDatabaseService();

        MultiProvider(
          providers: [
            Provider<UserWorkoutRepository>(
              create: (_) => SqfliteUserWorkoutRepositoryImpl(sqfliteService),
            ),
            Provider<WorkoutSummaryRepository>(
              create: (_) => SqfliteWorkoutSummaryRepositoryImpl(sqfliteService),
            ),
            // ... other providers
          ],
          child: const MyApp(),
        ),
        ```

    2.  **Full Regression Test:**
        *   Run the application on an emulator or physical device.
        *   Thoroughly test every feature: create a workout, edit it, run it, check the summary, delete it. The app should start with a clean slate.

*   **Git Commit Message:**
    ```
    feat(db): activate SQFlite as the primary database

    - Update dependency injection to provide the Sqflite repository implementations.
    - The application now uses SQFlite for all data persistence.
    - The Hive implementation remains in the codebase to allow for a quick rollback if necessary.
    ```

---

## Step 4: Final Cleanup - Remove Hive

**Goal:** Purge all legacy Hive code and dependencies from the project, leaving the codebase clean.

*   **Detailed Technical Tasks:**

    1.  **Delete Unused Files:**
        *   Delete the entire `lib/repositories/hive/` directory.
        *   Delete the old Hive database service file.
        *   Delete any Hive-specific generated files (`TypeAdapter`s).

    2.  **Remove Dependencies:**
        *   Open `pubspec.yaml`.
        *   Remove `hive`, `hive_flutter`, and `hive_generator`. Also remove `build_runner` if it is no longer needed.

    3.  **Finalize:**
        *   Run `flutter pub get` in your terminal.
        *   Run the app one last time to ensure it still works perfectly.

*   **Git Commit Message:**
    ```
    refactor(db): remove all unused Hive code and dependencies

    - Delete legacy Hive repository implementations, services, and generated files.
    - Remove Hive dependencies from pubspec.yaml.

    This is a pure cleanup commit with no functional changes.