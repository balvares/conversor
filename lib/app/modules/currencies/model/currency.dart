import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency {

  final String identifier;
  final String name;

  Currency({
    this.identifier,
    this.name,
  });

  Currency fromJson(String key, String value) => _$CurrencyFromJson(key, value);
}