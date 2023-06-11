import 'package:restox/models/address.dart';
import 'package:restox/models/error.dart';

class Restaurant {
  final String id;
  final String name;
  final String email;
  final String contact;
  final AddressInline address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJSON(Map<String, dynamic> json) => Restaurant(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      address: AddressInline.fromJSON(json['address']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt'])
  );
}

class GetRestaurantsResponse {
  final bool hasMore;
  final List<Restaurant> data;

  GetRestaurantsResponse({
    required this.hasMore,
    required this.data
  });

  factory GetRestaurantsResponse.fromJSON(Map<String, dynamic> json) {
    return GetRestaurantsResponse(
      hasMore: json['has_more'],
      data: (json['data'] as List).map((e) => Restaurant.fromJSON(e)).toList(),
    );
  }
}

class GetRestaurantsRet {
  final GetRestaurantsResponse? response;
  final ApiErrorV1? error;

  GetRestaurantsRet({this.response, this.error});
}

class GetRestaurantsParams {
  final int skip;
  final int limit;

  GetRestaurantsParams({
    required this.skip,
    required this.limit,
  });
}

class GetRestaurantParams {
  final String restaurantId;

  GetRestaurantParams({
    required this.restaurantId,
  });
}

class GetRestaurantResponse {
  final bool exists;
  final Restaurant data;

  GetRestaurantResponse({
    required this.exists,
    required this.data,
  });

  factory GetRestaurantResponse.fromJSON(Map<String, dynamic> json) {
    return GetRestaurantResponse(
        exists: json['exists'],
        data: Restaurant.fromJSON(json['data'])
    );
  }
}

class GetRestaurantRet {
  final GetRestaurantResponse? response;
  final ApiErrorV1? error;

  GetRestaurantRet({this.response, this.error});
}
