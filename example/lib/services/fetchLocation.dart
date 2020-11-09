import 'package:tracking/models/sendDataModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchLocation {
  FetchLocation(SendDataModel body) {
    _sendData(body.toMap());
  }

  var convertedDatatoJsonReg;
  var convertedDatatoJsonLog;

  void _sendData(body) async {
    //print('sendData JAFS');
    //print(body);
    final String phNo = "97715487s3";
    //print("1. " + phNo);
    await createCoordenadasUser(phNo);
    //await loginUser(phNo, '0');
  }

  Future createCoordenadasUser(String phoneNo) async {
    final String apiUrl =
        "http://visitzservice.azurewebsites.net/api/getauthcode-debug";

    var response = await http.post(apiUrl,
        body: phoneNo, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print("2. Hi from if Reg");
      convertedDatatoJsonReg = jsonDecode(response.body);
      print(convertedDatatoJsonReg);
    } else {
      convertedDatatoJsonReg = jsonDecode(response.body);
      print(convertedDatatoJsonReg);
      print("Error !!!");
    }
  }

  Future loginUser(String phoneNo, String code) async {
    final String apiUrl = "http://visitzservice.azurewebsites.net/api/";

    var response = await http.post(apiUrl + 'authenticate',
        body: json.encode({'PhoneNo': phoneNo, 'Code': code}),
        headers: {'Content-Type': 'application/json'});

    print("from loginUser PhoneNumber : " + phoneNo);
    print("from loginUser OTP : " + code);
    convertedDatatoJsonLog = jsonDecode(response.body);
    //responseString = response.body;
    print(convertedDatatoJsonLog.toString());

    if (response.statusCode == 200) {
      print("Hi from if Log");
      convertedDatatoJsonLog = jsonDecode(response.body);
      print(convertedDatatoJsonLog);

      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),) );

      return convertedDatatoJsonLog;
    } else {
      print("Error !!!" + convertedDatatoJsonLog.toString());
    }
  }
}
