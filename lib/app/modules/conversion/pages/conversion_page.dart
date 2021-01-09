import 'package:conversor/app/modules/conversion/services/conversion_service.dart';
import 'package:flutter/material.dart';
import 'package:conversor/app/shared/custom_button.dart';
import 'package:conversor/app/shared/custom_text_input.dart';
import 'package:conversor/app/modules/currencies/services/currency_service.dart';

class ConversionPage extends StatefulWidget {

  @override _ConversionPageState createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {

  final TextEditingController _originController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List _currencies = [];
  List _conversions = [];
  String _currencyFrom = '';
  String _currencyTo = '';
  double _convertedValue = 0.00;

  @override
  void initState() {
    
    super.initState();
    _getCurrencies();
  }

  Future _getCurrencies() async {

    dynamic currencies = await CurrencyService().getCurrencies().catchError((onError) {
      print('Erro ao trazer moedas.');
    });

    setState(() {
      _currencyFrom = currencies[0].identifier;
      _currencyTo = currencies[1].identifier;
      _currencies = currencies;
    });

    return Future.value(currencies);
  }

  Future _getConversions(String from, String to) async {

    dynamic conversions = await ConversionService().getConversions();

    setState(() {
      _conversions = conversions;
    });

    return;
  }

  Future _convert(String from, String to, double value) async {

    if (from != "USD" && to != "USD") {
      await _getConversions(from, "USD");
    }

    await _getConversions(from, to);
    dynamic conversionValue;

    _conversions.forEach((element) { 
      if(element.destiny == to) {
        conversionValue = element.value;
      }
    });

    setState(() {
      _convertedValue = double.parse(conversionValue) * value ;
    });

    return double.parse(conversionValue) * value;
  }

  List<DropdownMenuItem<String>> _buildOptionsCurrencies() {

    List<DropdownMenuItem<String>> l = [];

    for(var currency in _currencies) {
      l.add(DropdownMenuItem<String>(
        value: currency.identifier,
        child: Text(currency.name != null ? currency.identifier + ' | ' + currency.name : ''),
      ));
    }

    return l;
  }

  Widget _buildFromLabel() {

    return Text(
      'Converter de:',
    );
  }

  Widget _buildFromDropdown() {

    return DropdownButton<String>(
      value: _currencyFrom,
      items: _buildOptionsCurrencies(), 
      onChanged: (String newValue) {
        setState(() {
          _currencyFrom = newValue;
        });
      },
    );
  }

  Widget _buildToLabel() {

    return Text(
      'Para:',
    );
  }

  Widget _buildToDropdown() {

    return DropdownButton<String>(
      value: _currencyTo,
      items: _buildOptionsCurrencies(), 
      onChanged: (String newValue) {
        setState(() {
          _currencyTo = newValue;
        });
      },
    );
  }

  Widget _buildValueLabel() {

    return Text(
      'Valor:',
    );
  }

  Widget _buildValueInput(){

    return CustomTextInput(
      color: Colors.black12,
      labelColor: Colors.black54,
      controller: _originController,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _buildButton() {

    return CustomButton(
      label: 'Converter', 
      onPressed: () {
        _convert(_currencyFrom, _currencyTo, double.parse(_originController.text));
      },
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _buildResultLabel() {

    return Text(
      'Valor convertido: ',
    );
  }

  Widget _buildResult() {

    return Text(
      _convertedValue ?? '',
    );
  }

  Widget _buildBody() {

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValueLabel(),
          _buildValueInput(),
          SizedBox(height: 40),
          _buildFromLabel(),
          _buildFromDropdown(),
          SizedBox(height: 40),
          _buildToLabel(),
          _buildToDropdown(),
          SizedBox(height: 40),
          _buildButton(),
          SizedBox(height: 40),
          Row(
            children: [
              _buildResultLabel(),
              _convertedValue != null ? _buildResult() : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {

    final Text title = Text(
      'Converter moedas',
      style: TextStyle(color: Colors.white),
    );

    return AppBar(
      title: title,
      backgroundColor: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}