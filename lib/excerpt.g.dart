// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excerpt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExcerptAdapter extends TypeAdapter<Excerpt> {
  @override
  final int typeId = 0;

  @override
  Excerpt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Excerpt(
      title: fields[0] as String,
      mallets: (fields[1] as List).cast<String>(),
      selected: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Excerpt obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.mallets)
      ..writeByte(2)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExcerptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Excerpt _$ExcerptFromJson(Map<String, dynamic> json) => Excerpt(
      title: json['title'] as String,
      mallets:
          (json['mallets'] as List<dynamic>).map((e) => e as String).toList(),
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$ExcerptToJson(Excerpt instance) => <String, dynamic>{
      'title': instance.title,
      'mallets': instance.mallets,
      'selected': instance.selected,
    };
