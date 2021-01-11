import 'package:flutter/material.dart';
import 'package:conversor/app/shared/custom_button.dart';
import 'package:conversor/app/modules/currencies/pages/currency_page.dart';
import 'package:conversor/app/modules/conversion/pages/conversion_page.dart';
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Widget _buildConversorButton() {

    return CustomButton(
      height: 100,
      color: Colors.blue,
      label: 'Abrir Conversor',
      width: MediaQuery.of(context).size.width,
      onPressed: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ConversionPage()
        )),
      },
    );
  }

  Widget _buildListButton() {

    return CustomButton(
      height: 100,
      color: Colors.blue,
      label: 'Listagem de Moedas',
      width: MediaQuery.of(context).size.width,
      onPressed: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => CurrencyPage()
        )),
      },
    );
  }

  Widget _buildAppBar() {

    final Text title = Text(
      'Conversor',
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
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildConversorButton(),
            SizedBox(height: 20.0),
            _buildListButton(),
          ],
        ),
      ),
    );
  }
}
