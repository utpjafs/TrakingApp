import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracking/router/routerConsts.dart';
import 'package:tracking/ui/home.dart';
import 'package:tracking/ui/login.dart';
import 'package:tracking/ui/setting.dart';
import '../helper.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Navigation();
  }
}

class Navigation extends State<MainPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;
  bool _isOn = true;

  void toggle() {
    setState(() {
      _isOn = !_isOn;
      //_isOn ? Home().createState().onStart() : Home().createState().onStart();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);

      if (index == 0) {
        _navigatorKey.currentState.pushNamed(HomeViewRoute);
      }
      if (index == 1) {
        _navigatorKey.currentState.pushNamed(SettingViewRoute);
      }
      if (index == 2) {
        _navigatorKey.currentState.pushNamed(LoginViewRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Helper().checkPermissions();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Traking GPS'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        // leading: Container(
        //     color: Color(0x00ffffff),
        //     child: IconButton(
        //       icon: Icon(Icons.lightbulb_outline),
        //       iconSize: 30,
        //       onPressed: () {},
        // )),
        // actions: [
        //   Switch(
        //       value: _isOn,
        //       onChanged: (val) {
        //         toggle();
        //       }),
        // ],
        //flexibleSpace: Container(decoration: myBoxDecoration(opacity)),
        // leading: new Container(
        //   margin: const EdgeInsets.all(15.0),
        //   child: new Icon(
        //     Icons.gps_fixed,
        //     color: Colors.red,
        //     size: 30.0,
        //   ),
        // ),
      ),
      backgroundColor: Colors.deepOrange,
      body: WillPopScope(
        onWillPop: () async {
          if (_navigatorKey.currentState.canPop()) {
            _navigatorKey.currentState.pop();
            return true;
          }
          return true;
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: HomeViewRoute,
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case HomeViewRoute:
                return MaterialPageRoute(builder: (context) => Home());
              case SettingViewRoute:
                return MaterialPageRoute(builder: (context) => Setting());
            }
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home, color: Colors.white),
            title: new Text("Inicio"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.settings, color: Colors.white),
            title: new Text("Configuración"),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
