import 'package:calender/ui/calender/calender.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;

import 'package:googleapis_auth/auth_io.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/services/calender_services.dart';
import 'core/viewmodel/calender_viewmodel.dart';

class MyApp extends StatelessWidget {
  MyApp() : super();
  final List<String> _scopes = [CalendarApi.calendarScope];
  final _clientID = new ClientId(
      "285476165849-hcrji5mi7deb631bvkv12ljdsiefnvo0.apps.googleusercontent.com",
      "");

  Future<AuthClient> authenTication() async {
    AuthClient _client = await clientViaUserConsent(
      _clientID,
      _scopes,
      prompt,
    );

    return _client;
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthClient>(
        future: authenTication(),
        builder: (context, snapshot) {
          print(snapshot.data);

          if (snapshot.hasData)
            return Provider(
              create: (_) => CalendarClient(client: snapshot.data),
              child: MaterialApp(home: CalenderView()),
            );

          return Material(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()));
        });
  }
}
