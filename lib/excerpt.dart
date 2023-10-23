import 'package:hive/hive.dart';

part 'excerpt.g.dart';


@HiveType(typeId: 0)
class Excerpt extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<String> mallets;

  @HiveField(2)
  bool selected;

  Excerpt({required this.title, required this.mallets, this.selected = false});
}


