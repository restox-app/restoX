import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restox/api/orders.dart';
import 'package:restox/models/order.dart';
import 'package:restox/providers/restaurant.dart';

class OrderConfState {
  final String status;
  final String msg;

  OrderConfState({
    required this.status,
    required this.msg,
  });
}

class OrderNotifier extends StateNotifier<OrderConfState> {
  OrderNotifier(this._ref) : super(OrderConfState(
    status: 'loading',
    msg: 'Queueing Order',
  ));

  final Ref _ref;

  Future<void> placeOrder(String restaurantId) async {
    var _razorpay = Razorpay();

    PostOrderRet ret = await postOrder(PostOrderParams(pg: true, restaurantId: restaurantId));

    await Future.delayed(const Duration(milliseconds: 750));

    if (ret.error != null) {
      state = OrderConfState(
        status: 'failed',
        msg: 'Failed to Place Order',
      );
      return;
    }

    if (ret.response!.paymentGateway == 'razorpay') {
      var options = {
        //'key': 'rzp_test_Qxr7CdUoacYLJj',
        'key': 'rzp_test_8BTbGOj8uzLilz',
        'order_id': ret.response!.gatewayDetails.orderId,
        'name': 'RestoX',
      };

      _razorpay.open(options);

      await Future.delayed(const Duration(seconds: 2));
    }

    state = OrderConfState(
      status: 'loading',
      msg: 'Mocking Payment Details',
    );

    await Future.delayed(const Duration(milliseconds: 750));

    state = OrderConfState(
      status: 'loading',
      msg: 'Placing Order',
    );

    await Future.delayed(const Duration(milliseconds: 750));

    state = OrderConfState(
      status: 'successfull',
      msg: 'Order Placed Successfully',
    );

    await _ref.read(restaurantProvider.notifier).fetchCartItems(restaurantId);
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderConfState>((ref) {
  return OrderNotifier(ref);
});
