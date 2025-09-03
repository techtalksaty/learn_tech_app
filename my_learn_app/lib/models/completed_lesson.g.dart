// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompletedLessonAdapter extends TypeAdapter<CompletedLesson> {
  @override
  final int typeId = 3;

  @override
  CompletedLesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedLesson(
      category: fields[0] as String,
      lessonIds: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CompletedLesson obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.lessonIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedLessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
