import 'package:conversor/app/modules/currencies/model/currency.dart';
import 'package:conversor/app/shared/custom_text_input.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:conversor/app/modules/currencies/services/currency_service.dart';

class CurrencyPage extends StatefulWidget {

  @override _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  List _currencies = [];
  String _currencyFrom = '';
  String _currencyTo = '';
  String filter = 'identifier';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  Future<List> _refresh() async {

    List<Currency> currencies = await CurrencyService().getCurrencies();

    setState(() {
      _currencies = currencies;
    });
  }

  Widget _buildAppBar() {

    final Text title = Text(
      'Listagem de moedas',
      style: TextStyle(color: Colors.white),
    );

    return AppBar(
      title: title,
      backgroundColor: Colors.blue,
    );
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

  Widget _buildOrderByIdentifier() {

    final Radio radio = Radio(
      value: 'identifier',
      groupValue: filter,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (dynamic value) { 
        setState(() => filter = value);
        _refresh();
      },
    );

    final Text label = Text(
      'Ordenar por sigla',
      style: Theme.of(context).textTheme.bodyText1,
    );

    return Row(
      children: <Widget>[
        radio, label,
      ],
    );
  }

  Widget _buildOrderByName() {

    final Radio radio = Radio(
      value: 'name',
      groupValue: filter,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (dynamic value) => setState(() => filter = value),
    );

    final Text label = Text(
      'Ordenar por nome',
      style: Theme.of(context).textTheme.bodyText1,
    );

    return Row(
      children: <Widget>[
        radio, label,
      ],
    );
  }

  Widget _buildOptions() {

    Widget wg;

    wg = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildOrderByIdentifier(),
        SizedBox(width: 40.0,),
        _buildOrderByName(),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          wg,
        ],
      ),
    );
  }

  Widget _buildListTile(String identifier, String name) {

    return ListTile(
      title: Text(identifier + ' | ' + name),
    );
  }

  Widget _buildListView(BuildContext context) {

    final List currencies = [
      _buildOptions()
    ];

    final List l = _currencies;

    if (filter == 'identifier') {
      l.sort((a, b) {
        return a.identifier.toString().compareTo(b.identifier.toString());
      });
    } else {
      l.sort((a, b) {
        return a.name.toString().compareTo(b.name.toString());
      });
    }

    l.forEach((element) {
      currencies.add(_buildListTile(element.identifier, element.name));
    });

    return ListView.separated(
      itemCount: currencies.length,
      separatorBuilder: (context, int index) => Divider(thickness: 1),
      itemBuilder: (context, int index) => currencies[index], 
    );
  }

  Widget _buildBody() {

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
      child: _buildListView(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}