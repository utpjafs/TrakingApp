import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracking/router/routerConsts.dart';

import 'package:tracking/ui/home.dart';
import 'package:tracking/ui/login.dart';
import 'package:tracking/ui/setting.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => Home());
    case SettingViewRoute:
      return MaterialPageRoute(builder: (context) => Setting());
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginWidget());
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
