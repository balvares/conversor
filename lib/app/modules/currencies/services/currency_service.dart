import 'package:conversor/app/modules/currencies/model/currency.dart';
import 'package:conversor/app/modules/currencies/repositories/currency_repository.dart';

class CurrencyService {

  Future getCurrencies() async {

    Map<String, dynamic> currencies = await CurrencyRepository().getCurrencies();

    List<Currency> currenciesList = [];
    currencies.forEach((key, value) {
      currenciesList.add(Currency().fromJson(key, value));
    });

    return currenciesList;
  }
}