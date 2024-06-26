import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String currencyCode = 'USD';
  Map<String, double> prices = {};
  CoinData data = CoinData();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {

    var coinData = await data.getCoinData(currencyCode);

    setState(() {
      prices = coinData ?? {};
    });
  }

  Column listPrices() {
    List<CryptoCard> cards = [];
    for (String crypto in cryptoList) {
      cards.add(
          CryptoCard(
          value: prices[crypto] ??-1.0,
          currencyCode: currencyCode,
          cryptoCode: crypto)
      );
    }
    return Column(children: cards);
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    currenciesList.forEach((curency) {
      var item = DropdownMenuItem(
        child: Text(curency),
        value: curency,
      );
      dropDownItems.add(item);
    });
    return DropdownButton(
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          currencyCode = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItems = [];
    currenciesList.forEach((currency) {
      var item = Text(currency);
      pickerItems.add(item);
    });
    return CupertinoPicker(
      itemExtent: 20,
      onSelectedItemChanged: (int value) {
        setState(() {
          currencyCode = currenciesList[value];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          listPrices(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({required this.value, required this.currencyCode, required this.cryptoCode});

  final double value;
  final String currencyCode;
  final String cryptoCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCode = ${value.toStringAsFixed(2)} ${currencyCode}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
