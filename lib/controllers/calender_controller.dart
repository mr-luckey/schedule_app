import 'package:get/get.dart';
import 'package:schedule_app/model/event_model.dart';

import '../APIS/Api_Service.dart';
import '../model/Calender_model.dart';

class CalendarsController extends GetxController {
  final List<Event> apiEvents = [];
  final List<CalendarEvent> events = <CalendarEvent>[];

  // Edit event related properties
  final Rx<Event?> currentEditEvent = Rx<Event?>(null);
  final RxList<CalendarEvent> Editevent = <CalendarEvent>[].obs;
  final RxList<Event> EditapiEvents = <Event>[].obs;
  Future<void> loadEventsFromApi() async {
    try {
      final List<Event> apiEvents = await ApiService.getOrders();

      events
        ..clear()
        ..addAll(apiEvents.map((e) => e.toCalendarEvent()));
    } catch (e) {
      print('❌ _loadEventsFromApi error: $e');
    }
  }

  // Future<void> loadEventsFromApi() async {
  //   try {
  //     final List<Event> apiEvents = await ApiService.getOrders();
  //     events
  //       ..clear()
  //       ..addAll(apiEvents.map((e) => e.toCalendarEvent()));
  //   } catch (e) {
  //     print('❌ _loadEventsFromApi error: $e');
  //   }
  // }

  Future<void> loadEditData(String id) async {
    try {
      final List<Event> EditapiEvents = await ApiService.getOrders();
      Event event = EditapiEvents.firstWhere(
        (event) => event.id == id,
        orElse: () => throw Exception('Event not found'),
      );

      print("✅ Data matched event found!");

      // Store the event for editing
      currentEditEvent.value = event;
      this.EditapiEvents.value = EditapiEvents;

      // Print event details
      print("Event details:");
      print("ID: ${event.id}");
      print("Title: ${event.title}");
      print("Customer Name: ${event.customerName}");
      print("All events count: ${EditapiEvents.length}");
    } catch (e) {
      print('❌ Error in loadEditData: $e');
      currentEditEvent.value = null;
    }
  }

  // Helper method to get the current edit event
  Event? get editEvent => currentEditEvent.value;

  @override
  void onInit() {
    super.onInit();
    loadEventsFromApi();
  }
}
// class CalendarsController extends GetxController {
//   final List<Event> apiEvents = [];
//   final List<CalendarEvent> events = <CalendarEvent>[];
//   final List<CalendarEvent> Editevent = <CalendarEvent>[];
//   final List<Event> EditapiEvents = [];

//   Future<void> loadEventsFromApi() async {
//     try {
//       final List<Event> apiEvents = await ApiService.getOrders();

//       events
//         ..clear()
//         ..addAll(apiEvents.map((e) => e.toCalendarEvent()));
//     } catch (e) {
//       print('❌ _loadEventsFromApi error: $e');
//     }
//   }

//   Future<void> loadEditData(String id) async {
//     try {
//       final List<Event> EditapiEvents = await ApiService.getOrders();
//       Event event = EditapiEvents.firstWhere(
//         (event) => event.id == id,
//         orElse: () => throw Exception('Event not found'),
//       );

//       print("✅ Data matched event found!");

//       // Print event details by converting to map or accessing properties
//       print("Event details:");
//       print("ID: ${event.id}");
//       print("Title: ${event.title}");
//       print("Date: ${event.customerName}");

//       print("All events count: ${EditapiEvents.length}");
//     } catch (e) {
//       print('❌ Error in loadEditData: $e');
//     }
//   }

//   List<Event> getEventsById(String id) {
//     try {
//       return apiEvents.where((event) => event.id == id).toList();
//     } catch (e) {
//       print('❌ getEventsById error: $e');
//       return [];
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     loadEventsFromApi();
//   }
// }
