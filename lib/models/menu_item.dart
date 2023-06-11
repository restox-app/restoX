import 'package:restox/models/error.dart';

class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final int price;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJSON(Map<String, dynamic> json) => MenuItem(
      id: json['_id'],
      restaurantId: json['restaurant_id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt'])
  );
}

class GetMenuItemsResponse {
  final bool hasMore;
  final List<MenuItem> data;

  GetMenuItemsResponse({
    required this.hasMore,
    required this.data,
  });

  factory GetMenuItemsResponse.fromJSON(Map<String, dynamic> json) => GetMenuItemsResponse(
    hasMore: json['has_more'],
    data: (json['data'] as List).map((e) => MenuItem.fromJSON(e)).toList(),
  );
}

class GetMenuItemsRet {
  final GetMenuItemsResponse? response;
  final ApiErrorV1? error;

  GetMenuItemsRet({this.response, this.error});
}

class GetMenuItemsParams {
  final String restaurantId;
  final int skip;
  final int limit;

  GetMenuItemsParams({
    required this.restaurantId,
    required this.skip,
    required this.limit,
  });
}
