import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:conversor/app/shared/custom_button.dart';
import 'package:conversor/app/shared/custom_text_input.dart';
import 'package:conversor/app/modules/currencies/services/currency_service.dart';
import 'package:conversor/app/modules/conversion/services/conversion_service.dart';

class ConversionPage extends StatefulWidget {

  @override _ConversionPageState createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {

  List _currencies = [];
  List _conversions = [];
  String _currencyFrom = '';
  String _currencyTo = '';
  double _convertedValue = 0.00;

  final TextEditingController _originController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    
    super.initState();
    _getCurrencies();
  }

  void _onFail(String err) {

    final SnackBar snackbar = SnackBar(
      content: Text(err),
      action: SnackBarAction(label: 'Ok', onPressed: () {}),
    );

    _scaffoldKey.currentState.showSnackBar(snackbar); 
  }

  Future _getCurrencies() async {

    dynamic currencies = await CurrencyService().getCurrencies().catchError((onError) {
      _onFail('Ocorreu um erro ao listar as moedas. Tente novamente mais tarde.');
    });

    setState(() {
      _currencyFrom = currencies[0].identifier;
      _currencyTo = currencies[1].identifier;
      _currencies = currencies;
    });

    return Future.value(currencies);
  }

  Future _getConversions() async {

    dynamic conversions = await ConversionService().getConversions();

    setState(() {
      _conversions = conversions;
    });

    return conversions;
  }

  Future _convert(String from, String to, double amount) async {

    List cv = await _getConversions();
    dynamic conversionToUSD;
    dynamic conversionFromUSD;
    double resultUSD;

    if (from != "USD" && to != "USD") {
      conversionToUSD = cv.firstWhere((element) {
        return element.destiny == from;
      });

      resultUSD = amount / conversionToUSD.value;

      conversionFromUSD = cv.firstWhere((element) {
        return element.destiny == to;
      });

      setState(() {
        _convertedValue = conversionFromUSD.value * resultUSD ;
      });
    } 
    else if (to != "USD"){
      conversionFromUSD = cv.firstWhere((element) {
        return element.destiny == from;
      });

      resultUSD = amount * conversionFromUSD.value;

      setState(() {
        _convertedValue = resultUSD ;
      });
    } else {
      conversionFromUSD = cv.firstWhere((element) {
        return element.destiny == from;
      });

      resultUSD = amount / conversionFromUSD.value;

      setState(() {
        _convertedValue = resultUSD ;
      });
    }

    return _convertedValue;
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

  bool _validateFields() {

    if (_originController.text.isEmpty) {
      _onFail('Preencha o valor a ser convertido.');
      return false;
    }

    if (_currencyFrom == _currencyTo) {
      _onFail('Favor selecionar duas moedas diferentes para conversão.');
      return false;
    }

    if (double.parse(_originController.text) <= 0) {
      _onFail('O valor a ser convertido deve ser maior que zero.');
      return false;
    }

    return true;
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
      inputType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildButton() {

    return CustomButton(
      label: 'Converter', 
      width: MediaQuery.of(context).size.width,
      onPressed: () {
        _validateFields() ?? _convert(_currencyFrom, _currencyTo, double.parse(_originController.text));
      },
    );
  }

  Widget _buildResultLabel() {

    return Text(
      'Valor convertido: ',
      style: TextStyle(
        fontSize: 18,
      ),
    );
  }

  Widget _buildResult() {

    final NumberFormat nf = NumberFormat('#,##0.00', 'pt_BR');

    return Text(
      nf.format(_convertedValue) ?? '',
      style: TextStyle(
        fontSize: 18,
      ),
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
      body: SingleChildScrollView(
        child: _buildBody(),
      )
    );
  }
}