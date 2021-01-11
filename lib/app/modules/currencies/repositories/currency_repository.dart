import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyRepository {

  Future getCurrencies() async {

    dynamic res;
    final dynamic urlBase = 'http://api.currencylayer.com/';
    final dynamic accessKey = 'fd08b352ff7131ba3a3c7c5271b72895';

    final String url = 
      '$urlBase/list?access_key=$accessKey';
    
    final http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: { "Content-type": "application/json" },
    );

    if (response.statusCode > 206) {
      return getFromCache('currencies');
    }

    res = json.decode(response.body)['currencies'];
    saveOnCache(res).catchError((onError) {});

    return res;
  }

  Future saveOnCache(Map<String, dynamic> list) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('currencies');
    prefs.setString('currencies', json.encode(list));

    return;
  }

  Future getFromCache(String str) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    return json.decode(prefs.getString('currencies'));
  }
}