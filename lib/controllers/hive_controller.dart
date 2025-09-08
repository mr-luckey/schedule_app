// import 'package:hive/hive.dart';
// import 'package:schedule_app/model/event_model.dart';
// // import 'event_model.dart';

// class HiveService {
//   static const String eventsBox = 'events_box';

//   static Future<void> init() async {
//     await Hive.openBox<Event>(eventsBox);
//   }

//   static Future<void> addEvent(Event event) async {
//     final box = Hive.box<Event>(eventsBox);
//     await box.put(event.id, event);
//   }

//   static Future<void> updateEvent(Event event) async {
//     final box = Hive.box<Event>(eventsBox);
//     await box.put(event.id, event);
//   }

//   static Future<void> deleteEvent(String eventId) async {
//     final box = Hive.box<Event>(eventsBox);
//     await box.delete(eventId);
//   }

//   static Event? getEvent(String eventId) {
//     final box = Hive.box<Event>(eventsBox);
//     return box.get(eventId);
//   }

//   static List<Event> getAllEvents() {
//     final box = Hive.box<Event>(eventsBox);
//     return box.values.toList();
//   }

//   static List<Event> getEventsForDay(DateTime day) {
//     final allEvents = getAllEvents();
//     return allEvents.where((event) {
//       return isSameDay(event.startTime, day);
//     }).toList();
//   }

//   static bool isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }
