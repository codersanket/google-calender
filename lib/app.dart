import 'package:calender/core/constants/constants.dart';
import 'package:calender/ui/calender/calender.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/services/calender_services.dart';

class MyApp extends StatelessWidget {
  MyApp() : super();

  Future<AuthClient> authenTication() async {
    AuthClient _client = await clientViaUserConsent(
      Constants().clientID,
      Constants().scopes,
      prompt,
    );

    return _client;
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");

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
