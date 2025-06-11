import 'package:json_annotation/json_annotation.dart';

class BooleanConverter implements JsonConverter<bool?, int?> {
  const BooleanConverter();

  @override
  bool? fromJson(int? json) {
    if (json == null) {
      return null;
    }
    return json == 1;
  }

  @override
  int? toJson(bool? object) {
    if (object == null) {
      return null;
    }
    return object ? 1 : 0;
  }
}
