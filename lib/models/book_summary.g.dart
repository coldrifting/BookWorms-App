// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookSummaryAdapter extends TypeAdapter<BookSummary> {
  @override
  final int typeId = 3;

  @override
  BookSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookSummary(
      id: fields[0] as String,
      title: fields[1] as String,
      authors: (fields[2] as List).cast<String>(),
      difficulty: fields[3] as String,
      rating: fields[4] as double,
    )..imagePath = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, BookSummary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authors)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
