import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:restox/models/error.dart';
import 'package:restox/models/order.dart';

const String _url = 'http://127.0.0.1:5003';

Future<GetCartItemsRet> getCartItems(GetCartItemsParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/v1/cart?restaurant_id=${d.restaurantId}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    Iterable i = jsonDecode(response.body);

    return GetCartItemsRet(
      response: i.map((e) => CartItem.fromJSON(e)).toList(),
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

  return GetCartItemsRet(
    error: errorObj,
  );
}

Future<PostCartRet> postCart(PostCartParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await post(
      Uri.parse('$_url/v1/cart'),
      body: jsonEncode({
        'restaurant_id': d.restaurantId,
        'menu_item_id': d.menuItemId,
        'qty': d.qty,
      }),
      headers: {
        'Authorization': idToken!,
        'Content-Type': 'application/json',
      }
  );

  if (response.statusCode == 200) {
    return PostCartRet(
      response: response.statusCode,
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

  return PostCartRet(
    error: errorObj,
  );
}

Future<PatchCartRet> patchCart(PatchCartParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await patch(
    Uri.parse('$_url/v1/cart/${d.cartItemId}?qty=${d.qtyInc ? 'increment' : 'decrement'}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return PatchCartRet(
      response: response.statusCode,
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

  return PatchCartRet(
    error: errorObj,
  );
}

Future<DeleteCartRet> deleteCart(DeleteCartParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await delete(
    Uri.parse('$_url/v1/cart/${d.cartItemId}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return DeleteCartRet(
      response: response.statusCode,
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

  return DeleteCartRet(
    error: errorObj,
  );
}

Future<PostOrderRet> postOrder(PostOrderParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await post(
    Uri.parse('$_url/v1/orders'),
    body: jsonEncode({
      'pg': d.pg,
      'restaurant_id': d.restaurantId,
    }),
    headers: {
      'Authorization': idToken!,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);

    return PostOrderRet(
      response: NOrder.fromJSON(json),
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

  return PostOrderRet(
    error: errorObj,
  );
}

Future<GetOrdersRet> getOrders(GetOrdersParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/v1/orders?skip=${d.skip}&limit=${d.limit}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return GetOrdersRet(
      response: GetOrdersResponse.fromJSON(jsonDecode(response.body)),
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

  return GetOrdersRet(
    error: errorObj,
  );
}
