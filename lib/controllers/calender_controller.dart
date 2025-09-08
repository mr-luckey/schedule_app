import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/hive_controller.dart';
import 'package:schedule_app/model/event_model.dart';
// import 'event_model.dart';
// import 'hive_service.dart';

// class CalendarController extends GetxController {
//   final RxList<Event> events = <Event>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadEvents();
  // }

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
// }
