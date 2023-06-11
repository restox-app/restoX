import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:restox/models/buyer.dart';
import 'package:restox/models/error.dart';

const String _url = 'http://127.0.0.1:5001';

Future<PostBuyerRet> postBuyer() async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await post(
      Uri.parse('$_url/v1/'),
      headers: {
        'Authorization': idToken!,
      }
  );

  if (response.statusCode == 200) {
    return PostBuyerRet(
        response: Buyer.fromJSON(jsonDecode(response.body))
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

  return PostBuyerRet(
    error: errorObj,
  );
}