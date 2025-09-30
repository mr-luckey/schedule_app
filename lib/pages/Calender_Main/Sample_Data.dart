import 'package:schedule_app/model/Calender_model.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/model/event_model.dart';

final List<CalendarEvent> events = <CalendarEvent>[];

Future<void> _loadEventsFromApi() async {
  print('🔔 _loadEventsFromApi() triggered');
  print('📦 Current cached events length (before fetch): ${events.length}');
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

final Future<void> eventsLoaded = _loadEventsFromApi();

// Expose a public refresh hook to load events on-demand (e.g., after login)
Future<void> refreshCalendarEvents() async {
  await _loadEventsFromApi();
}
