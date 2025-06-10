import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/user_workout.dart';
import 'package:workout_timer_app/models/workout_summary.dart';

part 'backup_data.g.dart';

@JsonSerializable()
class BackupData {
  final List<UserWorkout> userWorkouts;
  final List<WorkoutSummary> workoutSummaries;

  BackupData({
    required this.userWorkouts,
    required this.workoutSummaries,
  });

  factory BackupData.fromJson(Map<String, dynamic> json) =>
      _$BackupDataFromJson(json);
  Map<String, dynamic> toJson() => _$BackupDataToJson(this);
}
