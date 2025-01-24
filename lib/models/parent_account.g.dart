// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentAdapter extends TypeAdapter<Parent> {
  @override
  final int typeId = 1;

  @override
  Parent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parent(
      username: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      profilePictureIndex: fields[3] as int,
      recentlySearchedBooks: (fields[4] as List).cast<String>(),
      children: (fields[5] as List).cast<Child>(),
    );
  }

  @override
  void write(BinaryWriter writer, Parent obj) {
    writer
      ..writeByte(6)
      ..writeByte(5)
      ..write(obj.children)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.profilePictureIndex)
      ..writeByte(4)
      ..write(obj.recentlySearchedBooks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
