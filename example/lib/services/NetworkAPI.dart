import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkAPI {
  final host = "https://reqres.in/api/";
  Map<String, String> commonHeaders = {
    'Agent': 'iPhone',
    'App-Version': '1.0.0'
  }; //common header properties for all http requests

  void httpGetRequest(
      String serviceUrl,
      Map<String, dynamic> headers,
      void completionHandler(
          bool status, List<Map<String, dynamic>> responseData)) async {
    var httpHeaders = this.commonHeaders;
    if (headers != null) {
      httpHeaders.addAll(headers);
    }

    try {
      final response =
          await http.get(this.host + serviceUrl, headers: httpHeaders);
      if (response.statusCode == 200) {
        final d = response.body;
        //print('WebServiceRequest - $serviceUrl \n Response - $d');
        completionHandler(true, json.decode(d));
      } else {
        completionHandler(false, null);
      }
    } catch (e) {
      completionHandler(false, null);
    }
  }

  void httpPostRequest(
      String serviceUrl,
      Map<String, dynamic> headers,
      Map<String, dynamic> postData,
      void completionHandler(
          bool status, List<Map<String, dynamic>> responseData)) async {
    var httpHeaders = this.commonHeaders;
    if (headers != null) {
      httpHeaders.addAll(headers);
    }

    try {
      final response = await http.post(this.host + serviceUrl,
          body: json.encode(postData), headers: httpHeaders);
      if (response.statusCode == 200) {
        final d = response.body;
        //print('WebServiceRequest - $serviceUrl \nResponse - $d');
        completionHandler(true, json.decode(d));
      } else {
        completionHandler(false, null);
      }
    } catch (e) {
      print('Exception - $e');
      completionHandler(false, null);
    }
  }
}
