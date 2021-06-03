import 'package:calender/core/enums/CalenderStatus.dart';
import 'package:calender/core/model/failure_model.dart';
import 'package:calender/core/services/calender_services.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:provider/provider.dart';

class CalenderViewModel with ChangeNotifier {
  CalenderViewModel({this.context}) : super() {
    getEvents();
  }
  BuildContext? context;
  CalenderStatus _calenderStatus = CalenderStatus.Initial;
  CalenderStatus get calenderStatus => _calenderStatus;
  Failure? failure;
  InsertStatus insertStatus = InsertStatus.Initial;

  List<CalendarEvent> _calenderEvent = [];
  List<CalendarEvent> get calenderEvent => _calenderEvent;

  getEvents() async {
    _calenderEvent.clear();
    _calenderStatus = CalenderStatus.Loading;
    notifyListeners();
    try {
      Events? temp = await Provider.of<CalendarClient>(context!, listen: false)
          .getEvents();
      temp?.items?.forEach((Event element) {
        _calenderEvent.add(CalendarEvent(
            eventName: element.summary == null ? "" : element.summary!,
            eventDate: element.start!.dateTime == null
                ? DateTime.now()
                : element.start!.dateTime!));
      });
      _calenderStatus = CalenderStatus.Loaded;
    } catch (e) {
      _calenderStatus = CalenderStatus.Error;
      failure = Failure(
          errorCode: "401",
          message: "Somehing went wrong.Please retry after some time");
    }

    notifyListeners();
  }

  Future insertEvents(String title, DateTime start, DateTime end) async {
    try {
      insertStatus = InsertStatus.Uploading;
      notifyListeners();
      String status = await Provider.of<CalendarClient>(context!, listen: false)
          .insert(title, start, end);
      _calenderEvent.add(CalendarEvent(
        eventName: title,
        eventDate: start,
      ));
      insertStatus = InsertStatus.Uploaded;

      notifyListeners();
      return status;
    } catch (e) {
      print(e);
      insertStatus = InsertStatus.Error;
      failure = Failure(errorCode: "401", message: "Something went wrong");
    }
  }
}
