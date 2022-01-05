import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_2/core/filter_options.dart';


part 'filter_options_response.g.dart';
@JsonSerializable()
class FilterOptionsResponse {
  FilterOptionsResponse({
    required this.filterOptions,
  });

  FilterOptions? filterOptions;

  factory FilterOptionsResponse.fromJson(Object? data) =>
      _$FilterOptionsResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FilterOptionsResponseToJson(this);
}
