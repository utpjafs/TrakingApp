import 'package:tracking/controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/BlockButtonWidget.dart';
import 'package:flutter/material.dart';
import '../helpers/app_config.dart' as config;
import 'home.dart';
import 'mainPage.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    // if (userRepo.currentUser.value.apiToken != null) {
    //Navigator.of(context).pushReplacementNamed('/Login', arguments: 2);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: null,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(37),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 120,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(37),
              child: Text(
                "S.of(context).lets_start_with_login",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding:
                  EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 20),
              width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _con.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => _con.user.email = input,
                      validator: (input) =>
                          !input.contains('@') ? "Validar email" : null,
                      decoration: InputDecoration(
                        labelText: "e-mail",
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'alex@localix.com.pe',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.alternate_email,
                            color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _con.user.password = input,
                      validator: (input) => input.length < 3
                          ? "S.of(context).should_be_more_than_3_characters"
                          : null,
                      obscureText: _con.hidePassword,
                      decoration: InputDecoration(
                        labelText: "password",
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '••••••••••••',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock_outline,
                            color: Theme.of(context).accentColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              // _con.hidePassword = !_con.hidePassword;
                            });
                          },
                          color: Theme.of(context).focusColor,
                          icon: Icon(_con.hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    BlockButtonWidget(
                      text: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.orange,
                      onPressed: () {
                        // _con.loading = true;
                        _con.login(context);
                      },
                    ),
                    SizedBox(height: 15),
                    FlatButton(
                      onPressed: () {
                        print('PERU');
                        //MaterialPageRoute(builder: (context) => MainPage());
                        //_onItemTapped(2);

                        //Navigator.of(context).pushReplacementNamed('/Home');

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Home()),
                        // );
                      },
                      shape: StadiumBorder(),
                      textColor: Theme.of(context).hintColor,
                      child: Text("S.of(context).skip"),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    ),
//                      SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
