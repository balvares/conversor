import 'package:json_annotation/json_annotation.dart';

part 'conversion.g.dart';

@JsonSerializable()
class Conversion {

  final String origin;
  final String destiny;
  final double value;

  Conversion({
    this.origin,
    this.destiny,
    this.value,
  });

  Conversion fromJson(String key1, String key2, double value) => _$ConversionFromJson(key1, key2, value);
}