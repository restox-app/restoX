import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:restox/models/error.dart';
import 'package:restox/models/menu_item.dart';
import 'package:restox/models/restaurant.dart';

const String _url = 'http://127.0.0.1:5002';

Future<GetRestaurantsRet> getRestaurants(GetRestaurantsParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/v1?skip=${d.skip}&limit=${d.limit}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return GetRestaurantsRet(
      response: GetRestaurantsResponse.fromJSON(jsonDecode(response.body)),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetRestaurantsRet(
    error: errorObj,
  );
}

Future<GetRestaurantRet> getRestaurant(GetRestaurantParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/v1/${d.restaurantId}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return GetRestaurantRet(
      response: GetRestaurantResponse.fromJSON(jsonDecode(response.body)),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetRestaurantRet(
    error: errorObj,
  );
}

Future<GetMenuItemsRet> getMenuItems(GetMenuItemsParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/v1/${d.restaurantId}/menu?skip=${d.skip}&limit=${d.limit}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return GetMenuItemsRet(
      response: GetMenuItemsResponse.fromJSON(jsonDecode(response.body)),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetMenuItemsRet(
    error: errorObj,
  );
}
