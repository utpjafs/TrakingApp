import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking/services/locationService.dart';
import 'package:tracking/models/locationModel.dart';
import 'package:tracking/ui/login.dart';
import 'package:tracking/ui/mainPage.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocationModel>.value(
      value: LocationService().locationStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Traking GPS',
        color: Colors.white,
        home: (true) ? MainPage() : LoginWidget(),
      ),
    );
  }
}
