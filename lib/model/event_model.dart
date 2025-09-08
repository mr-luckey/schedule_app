import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime endTime;

  @HiveField(4)
  final int guests;

  @HiveField(5)
  final String eventType;

  @HiveField(6)
  final String package;

  @HiveField(7)
  final String customerName;

  @HiveField(8)
  final String customerEmail;

  @HiveField(9)
  final String customerContact;

  @HiveField(10)
  final String hall;

  @HiveField(11)
  final String specialRequirements;

  Event({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.guests,
    required this.eventType,
    required this.package,
    required this.customerName,
    required this.customerEmail,
    required this.customerContact,
    required this.hall,
    this.specialRequirements = '',
  });

  String get timeRange {
    return '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}';
  }

  String get formattedDate {
    return DateFormat('MMMM d, yyyy').format(startTime);
  }

  String get duration {
    final difference = endTime.difference(startTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours == 0) {
      return '$minutes minutes';
    } else if (minutes == 0) {
      return '$hours hours';
    } else {
      return '$hours hours $minutes minutes';
    }
  }

  String get timeRemaining {
    final now = DateTime.now();
    final difference = startTime.difference(now);

    if (difference.isNegative) {
      return 'Past event';
    } else if (difference.inDays > 0) {
      return 'In ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'In ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else {
      return 'In ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    }
  }
}
