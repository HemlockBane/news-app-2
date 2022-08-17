import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  Category({
    required this.id,
    required this.name,
  });

  int? id;
  String? name;

  factory Category.fromJson(Object? data) =>
      _$CategoryFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [id, name];

  @override
  bool? get stringify => true;
}
