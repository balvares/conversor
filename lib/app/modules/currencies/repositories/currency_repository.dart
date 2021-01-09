import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyRepository {

  Future<Map<String, dynamic>> getCurrencies() async {

    final dynamic urlBase = 'http://api.currencylayer.com/';
    final dynamic accessKey = 'fd08b352ff7131ba3a3c7c5271b72895';

    final String url = 
      '$urlBase/list?access_key=$accessKey';
    
    final http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: { "Content-type": "application/json" },
    );

    if (response.statusCode > 206) {
      return Future.error('Falha');
    }

    return json.decode(response.body);
  }
}