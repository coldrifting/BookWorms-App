// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassroomAdapter extends TypeAdapter<Classroom> {
  @override
  final int typeId = 5;

  @override
  Classroom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Classroom(
      classroomName: fields[0] as String,
      teacherName: fields[1] as String,
      students: (fields[2] as List).cast<Student>(),
      bookshelf: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Classroom obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.classroomName)
      ..writeByte(1)
      ..write(obj.teacherName)
      ..writeByte(2)
      ..write(obj.students)
      ..writeByte(3)
      ..write(obj.bookshelf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassroomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
