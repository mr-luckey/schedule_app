import 'package:get/get.dart';
import 'package:schedule_app/model/event_model.dart';

import '../APIS/Api_Service.dart';
import '../model/Calender_model.dart';
class CalendarsController extends GetxController {
  final List<Event> apiEvents = [];
  final List<CalendarEvent> events = <CalendarEvent>[];

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

  @override
  void onInit() {
    super.onInit();
    loadEventsFromApi();
  }


}
