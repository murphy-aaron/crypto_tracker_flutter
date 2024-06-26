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
  double btcPrice = -1.00;
  CoinData data = CoinData();

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void updateUI() async {

    var coinData = await data.getCoinData(currencyCode);

    setState(() {
      if (coinData == null) {
        btcPrice = -1.00;
      } else {
        btcPrice = coinData['rate'];
      }
    });
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
          btcPrice = -1.0;
          currencyCode = value;
          updateUI();
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
          btcPrice = -1.0;
          currencyCode = currenciesList[value];
          updateUI();
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
          Padding(
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
                  '1 BTC = ${btcPrice > -1 ? btcPrice.toStringAsFixed(2) : '?'} ${currencyCode}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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