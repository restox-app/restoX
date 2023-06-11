import 'package:restox/models/error.dart';

class Buyer {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  Buyer({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Buyer.fromJSON(Map<String, dynamic> json) {
    return Buyer(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PostBuyerRet {
  final Buyer? response;
  final ApiErrorV1? error;

  PostBuyerRet({this.response, this.error});
}