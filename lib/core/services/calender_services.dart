import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';

class CalendarClient {
  final AuthClient _authClient;
  CalendarClient({AuthClient? client})
      : _authClient = client!,
        super();

  Future<String> insert(title, DateTime startTime, DateTime endTime) async {
    var calendar = CalendarApi(_authClient);

    String calendarId = "primary";
    EventDateTime start = new EventDateTime()
      ..dateTime = startTime
      ..timeZone = "GMT+05:00";

    EventDateTime end = new EventDateTime()
      ..timeZone = "GMT+05:00"
      ..dateTime = endTime;

    Event event = Event()
      ..summary = title
      ..start = start
      ..end = end; // Create object of event

    try {
      calendar.events.insert(event, calendarId).then((value) {
        if (value.status == "confirmed") {
          return "Done";
        } else {
          return "Something went wrong";
        }
      });
    } catch (e) {
      rethrow;
    }
    return "";
  }

  Future<Events?> getEvents() async {
    print(_authClient);
    var calendar = CalendarApi(_authClient);
    try {
      Events temp = await calendar.events.list("primary");

      return temp;
    } catch (e) {
      rethrow;
    }
  }
}
