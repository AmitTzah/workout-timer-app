import 'package:json_annotation/json_annotation.dart';

part 'goal.g.dart';

@JsonSerializable()
class Goal {
  String description;

  DateTime targetDate;

  double progress; // e.g., 0.0 to 1.0 or specific value

  Goal({
    required this.description,
    required this.targetDate,
    this.progress = 0.0,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
  Map<String, dynamic> toJson() => _$GoalToJson(this);
}
