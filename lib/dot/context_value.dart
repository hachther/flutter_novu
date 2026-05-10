import 'package:json_annotation/json_annotation.dart';

part 'context_value.g.dart';

@JsonSerializable()
class ContextValue {
  final String id;
  final Map<String, dynamic>? data;

  ContextValue({
    required this.id,
    this.data,
  });

  factory ContextValue.fromJson(Map<String, dynamic> json) => _$ContextValueFromJson(json);

  Map<String, dynamic> toJson() => _$ContextValueToJson(this);
}