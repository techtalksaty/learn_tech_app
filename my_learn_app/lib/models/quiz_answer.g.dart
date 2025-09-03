// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizAnswerAdapter extends TypeAdapter<QuizAnswer> {
  @override
  final int typeId = 4;

  @override
  QuizAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizAnswer(
      category: fields[0] as String,
      answeredQuestions: (fields[1] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.answeredQuestions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
