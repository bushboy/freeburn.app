import 'package:meta/meta.dart';

@immutable
class PlanModel {
  final String id;
  final String name;
  final String days;
  final String price;

  const PlanModel({required this.id,
    required this.name,
    required this.days,
    required this.price});

  PlanModel.fromJson(Map<String, dynamic> json)
      : id = json['plan_id'],
        name = json['name'],
        days = json['day'],
        price = json['price'];
}
