import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/workout_set.dart';

part 'workout_completion_details.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkoutCompletionDetails {
  final bool wasStoppedPrematurely;
  final List<WorkoutSet> finalPerformedSets;

  WorkoutCompletionDetails(this.wasStoppedPrematurely, this.finalPerformedSets);

  factory WorkoutCompletionDetails.fromJson(Map<String, dynamic> json) => _$WorkoutCompletionDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutCompletionDetailsToJson(this);
}
