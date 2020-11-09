import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sms/sms.dart';
import 'package:tracking/file_manager.dart';
import 'package:tracking/location_service_repository.dart';

import 'package:tracking/models/locationModel.dart';
import 'package:tracking/services/sms.dart';
import 'package:tracking/services/sharedPreferencesService.dart';
import '../helper.dart';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:background_locator/location_dto.dart';

import '../location_callback_handler.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  bool isLoading = false;
  ReceivePort port = ReceivePort();

  String logStr = '';
  bool isRunning;
  LocationDto lastLocation;
  DateTime lastTimeLocation;

  void initState() {
    isRunning = false;
    super.initState();

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateUI(LocationDto data) async {
    final log = await FileManager.readLogFile();
    await _updateNotificationText(data);

    setState(() {
      if (data != null) {
        lastLocation = data;
        lastTimeLocation = DateTime.now();
      }
      logStr = log;
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "GPS Tracking App",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }

  Widget build(BuildContext context) {
    Helper helper = new Helper();
    var location = Provider.of<LocationModel>(context);

    final loader = helper.loader('¡Espere el envío de sms!');

    String longAddressText = helper.setLongAdressText(location);

    String latitudeAndLongitudeText =
        helper.setLatitudeAndLongitudeText(location);

    String altitudeText = helper.setAltitudeText(location);

    String speedText = helper.setSpeedText(location);

    DateTime timestampText = helper.setTimestampText(location);

    final String loadingText = '-';

    List<String> phoneNumber = [];
    String googleLocationLinkText;
    if (location != null) {
      googleLocationLinkText =
          'http://www.google.com/maps/place/${location.latitude},${location.longitude}';
    }

    String messageToSend = '$googleLocationLinkText';
    String messageToShare =
        'Actual dirección: $longAddressText\n---\nActual velocidad: $speedText\n---\nUbicación link: $googleLocationLinkText';

    void _showConfirmationSmsDialog(sendSms) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: new Text("Confirmación de envío",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            content: RichText(
              text: sendSms
                  ? TextSpan(
                      children: [
                        TextSpan(
                          text: "Mensaje fue enviado",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " a ${phoneNumber[0]}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : TextSpan(
                      children: [
                        TextSpan(
                          text: "No se ha enviado el mensaje",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " a $messageToSend",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: "\n\n¡Inténtalo de nuevo!",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
            ),
            actions: <Widget>[
              new FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                color: Colors.greenAccent,
                child: new Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showSmsDialog() {
      SharedPreferencesService()
          .loadStringData('phoneNumber')
          .then((phoneNumberValue) {
        phoneNumber.add(phoneNumberValue);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: new Text("¿Realmente quieres enviar tu posición por SMS?",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Destinatario:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\n${phoneNumber[0]}",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: "\n\nMensaje:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\n$messageToSend",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                color: Colors.greenAccent,
                child: new Text(
                  "Enviar!",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  await Sms().send('$messageToSend', phoneNumber).then((value) {
                    new Timer(const Duration(milliseconds: 3000), () {
                      bool isSend = value.state == SmsMessageState.Sent;
                      isLoading = false;
                      _showConfirmationSmsDialog(isSend);
                      setState(() {
                        isLoading = false;
                      });
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                color: Colors.redAccent,
                child: new Text(
                  "¡No envíe!",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    var cardLocalisationData = [
      {
        'title': '${timestampText ?? loadingText}',
        'description': 'Última Actualización',
        'icon': Icons.calendar_today
      },
      {
        'title': '${longAddressText ?? loadingText}',
        'description': 'Dirección',
        'icon': Icons.home
      },
      {
        'title': '${latitudeAndLongitudeText ?? loadingText}',
        'description': 'Coordenadas',
        'icon': Icons.gps_fixed
      },
      {
        'title': '${altitudeText ?? loadingText}',
        'description': 'Altitud',
        'icon': Icons.arrow_upward
      },
      {
        'title': '${speedText ?? loadingText}',
        'description': 'Velocidad',
        'icon': Icons.arrow_forward_ios
      },
    ];

    return new Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Stack(
        children: [
          new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: cardLocalisationData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 3.0),
                      child: Card(
                        color: Color.fromRGBO(64, 75, 96, 1.0),
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                              border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.white24),
                              ),
                            ),
                            child: Icon(cardLocalisationData[index]['icon'],
                                color: Colors.white),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: '${cardLocalisationData[index]['title']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              text:
                                  '${cardLocalisationData[index]['description']}',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          onTap: () => {
                            _showAlert(
                                context,
                                '${cardLocalisationData[index]['description']}',
                                cardLocalisationData[index]['title'])
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          isLoading == true ? loader : Container(),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.sms),
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    _showSmsDialog();
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, bottom: 70.0, right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.share),
                  backgroundColor: Colors.lightBlue,
                  onPressed: () {
                    Share.share('$messageToShare');
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 0.0, left: 0.0, bottom: 130.0, right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.lightbulb_outline),
                  backgroundColor: (isRunning) ? Colors.green : Colors.orange,
                  onPressed: () {
                    print(isRunning);
                    (isRunning == false) ? onStart() : onStop();
                  }),
            ),
          )
        ],
      ),
    );
  }

  void onStop() async {
    print('onStop');
    BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
      lastTimeLocation = null;
      lastLocation = null;
    });
  }

  void onStart() async {
    print('onStart');

    if (await _checkLocationPermission()) {
      _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastTimeLocation = null;
        lastLocation = null;
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  void _startLocator() {
    Map<String, dynamic> data = {'countInit': 1};
    BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIcon: '',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }

  void _showAlert(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
            ));
  }
}
