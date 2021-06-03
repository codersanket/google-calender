import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class Constants {
  final List<String> _scopes = [CalendarApi.calendarScope];
  final ClientId _clientID = new ClientId(
      "285476165849-hcrji5mi7deb631bvkv12ljdsiefnvo0.apps.googleusercontent.com",
      "");

  List<String> get scopes => _scopes;

  ClientId get clientID => _clientID;
}
