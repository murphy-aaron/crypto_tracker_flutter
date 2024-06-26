import 'package:crypto_tracker_flutter/utilities/constants.dart';
import 'package:http/http.dart';
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future getCoinData(String currencyCode) async {

    Map<String, double> prices = {};

    for (String crypto in cryptoList) {
      Uri uri = Uri.https(
          kApiHost,
          '$kApiPath$crypto/$currencyCode',
          {'apikey': kApiKey }
      );
      Response response = await get(uri);
      if (response.statusCode == 200) {
        prices[crypto] = jsonDecode(response.body)['rate'];
      } else {
        print(response.statusCode);
      }
    }

    return prices;
  }

}