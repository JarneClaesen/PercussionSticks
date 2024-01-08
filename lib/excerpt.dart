import 'package:isar/isar.dart';

part 'excerpt.g.dart';

@Collection()
class Excerpt {
  Id id = Isar.autoIncrement;

  late String title;
  late List<String> mallets;
  late bool selected;

  // Convert an Excerpt instance into a Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include ID if you want to keep track of it
      'title': title,
      'mallets': mallets,
      'selected': selected,
    };
  }

  // Create an Excerpt instance from a Map.
  static Excerpt fromJson(Map<String, dynamic> json) {
    Excerpt excerpt = Excerpt()
      ..title = json['title']
      ..mallets = List<String>.from(json['mallets'])
      ..selected = json['selected'];
    if (json.containsKey('id')) {
      excerpt.id = json['id'];
    }
    return excerpt;
  }
}
