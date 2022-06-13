// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stopwatch_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopwatchDataAdapter extends TypeAdapter<StopwatchData> {
  @override
  final int typeId = 1;

  @override
  StopwatchData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopwatchData(
      time: fields[0] as String,
      laps: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StopwatchData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.laps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopwatchDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}