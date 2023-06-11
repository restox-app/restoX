import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restox/api/orders.dart';
import 'package:restox/models/order.dart';

class OrdersState {
  final GetOrdersResponse orderRes;

  OrdersState({
    required this.orderRes
  });
}

class OrdersNotifier extends StateNotifier<AsyncValue<OrdersState>> {
  OrdersNotifier() : super(AsyncValue.data(OrdersState(orderRes: GetOrdersResponse(hasMore: true, data: [])))) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    state = const AsyncValue.loading();

    GetOrdersRet ret = await getOrders(GetOrdersParams(skip: 0, limit: 10));

    if (ret.error != null) {
      state = AsyncValue.error(ret.error!, StackTrace.current);
      return;
    }

    state = AsyncValue.data(OrdersState(
      orderRes: ret.response!,
    ));
  }

  Future<void> loadMoreOrders() async {
    GetOrdersRet ret = await getOrders(GetOrdersParams(skip: state.value!.orderRes.data.length, limit: 10));

    if (ret.error != null) {
      throw ret.error!;
    }

    state = AsyncValue.data(OrdersState(
      orderRes: GetOrdersResponse(
        hasMore: ret.response!.hasMore,
        data: [
          ...state.value!.orderRes.data,
          ...ret.response!.data,
        ],
      ),
    ));
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, AsyncValue<OrdersState>>((ref) {
  return OrdersNotifier();
});
