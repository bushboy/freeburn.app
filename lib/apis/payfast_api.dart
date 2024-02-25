//import 'package:payfast/payfast.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class PayfastApi
{
  static String baseURL = 'https://sandbox.payfast.co.za';

  var client = new http.Client();

  Future<String> payFastPayment({
    String? amount,
    String? item_name,
  }) async {
    Map<String, String>? requestHeaders;

    final queryParameters = {
      'merchant_key': '46f0cd694581a',
      'merchant_id': '10000100',
      'amount': '$amount',
      'item_name': '$item_name',
      'return_url': 'http://localhost:8080/#/onSuccess',
      'cancel_url': 'http://localhost:8080/#/onCancel',
    };
    Uri uri = Uri.https(baseURL, "/eng/process", queryParameters);
    print("URI ${uri.data}");
    final response = await client.put(uri, headers: requestHeaders);
    print("Response body ${response.body}");
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 203 ||
        response.statusCode == 204) {
      return response.body;
    } else if (response.body != null) {
      return Future.error(response.body);
    } else {
      return Future.error('${response.toString()}');
    }
  }
}