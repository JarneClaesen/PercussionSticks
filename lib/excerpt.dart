import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'excerpt.g.dart';


@HiveType(typeId: 0)
@JsonSerializable()
class Excerpt extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<String> mallets;

  @HiveField(2)
  bool selected;

  Excerpt({required this.title, required this.mallets, this.selected = false});

  // JSON serialization
  factory Excerpt.fromJson(Map<String, dynamic> json) => _$ExcerptFromJson(json);
  Map<String, dynamic> toJson() => _$ExcerptToJson(this);
}


