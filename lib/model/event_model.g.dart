// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      title: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      guests: fields[4] as int,
      eventType: fields[5] as String,
      package: fields[6] as String,
      customerName: fields[7] as String,
      customerEmail: fields[8] as String,
      customerContact: fields[9] as String,
      hall: fields[10] as String,
      specialRequirements: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.guests)
      ..writeByte(5)
      ..write(obj.eventType)
      ..writeByte(6)
      ..write(obj.package)
      ..writeByte(7)
      ..write(obj.customerName)
      ..writeByte(8)
      ..write(obj.customerEmail)
      ..writeByte(9)
      ..write(obj.customerContact)
      ..writeByte(10)
      ..write(obj.hall)
      ..writeByte(11)
      ..write(obj.specialRequirements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
