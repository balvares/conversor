import 'package:conversor/app/modules/conversion/models/conversion.dart';
import 'package:conversor/app/modules/conversion/repositories/conversion_repository.dart';

class ConversionService {

  Future<List<Conversion>> getConversions() async {

    Map<String, dynamic> response = await ConversionRepository().getConversions();

    Map<String, dynamic> conversions = response['quotes'];

    List<Conversion> conversionsList = [];
    conversions.forEach((key, value) {
      String key1 = key.substring(0, 3);
      String key2 = key.substring(3);
      conversionsList.add(Conversion().fromJson(key1, key2, double.parse(value.toString())));
    });

    return conversionsList;
  }
}