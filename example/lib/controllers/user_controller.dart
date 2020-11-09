import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:tracking/ui/home.dart';
import 'package:tracking/ui/mainPage.dart';
import '../models/user.dart';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool loading = false;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void login(context) async {
    print('login');
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      //   loading = true;
      //   OverlayEntry loader = Helper.overlayLoader(context);
      //   Overlay.of(context).insert(loader);123456781212121
      //   repository.login(user).then((value) {
      //     loader.remove();
      //     // loading = false;
      //     if (value != null && value.apiToken != null) {
      //       scaffoldKey.currentState.showSnackBar(SnackBar(
      //         content: Text(S.current.welcome + value.name),
      //       ));

      // // Navigator.push(
      // //     context, MaterialPageRoute(builder: (context) => MainPage()));
      //Navigator.of(context).pushNamed('/Home');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainPage()));

      // Navigator.of(scaffoldKey.currentContext)
      //     .pushReplacementNamed('/Home', arguments: 2);
      //Navigator.of(context).pushReplacementNamed('/Home');
      //Navigator.of(context).pushNamed("/Home");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home()),
      // );
      //     } else {
      //       scaffoldKey.currentState.showSnackBar(SnackBar(
      //         content: Text(S.current.wrong_email_or_password),
      //       ));
      //     }
      //   });
    }
  }
}
