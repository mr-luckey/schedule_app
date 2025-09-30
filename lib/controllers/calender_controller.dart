import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/hive_controller.dart';
import 'package:schedule_app/model/event_model.dart';

import '../APIS/Api_Service.dart';
import '../model/Calender_model.dart';
// import 'event_model.dart';
// import 'hive_service.dart';

class CalendarsController extends GetxController {
  final List<Event> apiEvents = [];
  final List<CalendarEvent> events = <CalendarEvent>[];

  Future<void> loadEventsFromApi() async {
    // print('🔔 _loadEventsFromApi() triggered');
    // print('📦 Current cached events length (before fetch): ${apiEvents.length}');
    try {
      print('🌐 Calling ApiService.getOrders() ...');
      final List<Event> apiEvents = await ApiService.getOrders();
      print('✅ getOrders returned ${apiEvents.length} items');

      events
        ..clear()
        ..addAll(apiEvents.map((e) => e.toCalendarEvent()));
      print('🟢 Events list updated. New length: ${events.length}');
    } catch (e) {
      print('❌ _loadEventsFromApi error: $e');
      // Ignore errors silently to avoid impacting existing screens
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadEventsFromApi();
  }

//   void loadEvents() {
//     events.value = HiveService.getAllEvents();
//   }

//   List<Event> getEventsForDay(DateTime day) {
//     return events.where((event) {
//       return HiveService.isSameDay(event.startTime, day);
//     }).toList();
//   }

//   void addEvent(Event event) {
//     events.add(event);
//     HiveService.addEvent(event);
//   }

//   void updateEvent(Event event) {
//     final index = events.indexWhere((e) => e.id == event.id);
//     if (index != -1) {
//       events[index] = event;
//       HiveService.updateEvent(event);
//     }
//   }

//   void deleteEvent(String eventId) {
//     events.removeWhere((event) => event.id == eventId);
//     HiveService.deleteEvent(eventId);
//   }
}
