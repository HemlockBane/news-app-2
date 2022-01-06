// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_options_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterOptionsResponse _$FilterOptionsResponseFromJson(
        Map<String, dynamic> json) =>
    FilterOptionsResponse(
      filterOptions: json['filterOptions'] == null
          ? null
          : FilterOptions.fromJson(json['filterOptions'] as Object),
    );

Map<String, dynamic> _$FilterOptionsResponseToJson(
        FilterOptionsResponse instance) =>
    <String, dynamic>{
      'filterOptions': instance.filterOptions,
    };
