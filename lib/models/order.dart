import 'package:restox/models/error.dart';
import 'package:restox/models/menu_item.dart';

class GatewayDetails {
  final String? paymentId;
  final String? orderId;

  GatewayDetails({
    this.paymentId,
    this.orderId
  });

  factory GatewayDetails.fromJSON(Map<String, dynamic> json) {
    return GatewayDetails(
      paymentId: json['payment_id'],
      orderId: json['order_id'],
    );
  }
}

class NOrder {
  final String id;
  final String buyerId;
  final String restaurantId;
  final String status;
  final String paymentGateway;
  final String paymentStatus;
  final GatewayDetails gatewayDetails;
  final List<CartItem> cartItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  NOrder({
    required this.id,
    required this.buyerId,
    required this.restaurantId,
    required this.status,
    required this.paymentGateway,
    required this.paymentStatus,
    required this.gatewayDetails,
    required this.cartItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NOrder.fromJSON(Map<String, dynamic> json) {
    return NOrder(
      id: json['_id'],
      buyerId: json['buyer_id'],
      restaurantId: json['restaurant_id'],
      status: json['status'],
      paymentGateway: json['payment_gateway'],
      paymentStatus: json['payment_status'],
      gatewayDetails: GatewayDetails.fromJSON(json['gateway_details']),
      cartItems: (json['cart_items'] == null ? [] : json['cart_items'] as List).map((e) => CartItem.fromJSON(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CartItem {
  final String id;
  final String buyerId;
  final String restaurantId;
  final String menuItemId;
  final String? orderId;
  final int qty;
  final int price;
  final bool ordered;
  final MenuItem menuItem;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItem({
    required this.id,
    required this.buyerId,
    required this.restaurantId,
    required this.menuItemId,
    this.orderId,
    required this.qty,
    required this.price,
    required this.ordered,
    required this.menuItem,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CartItem.fromJSON(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      buyerId: json['buyer_id'],
      restaurantId: json['restaurant_id'],
      menuItemId: json['menu_item_id'],
      orderId: json['order_id'],
      qty: json['qty'],
      price: json['price'],
      ordered: json['ordered'],
      menuItem: MenuItem.fromJSON(json['menu_item']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class GetCartItemsParams {
  final String restaurantId;

  GetCartItemsParams({
    required this.restaurantId,
  });
}

class GetCartItemsRet {
  final List<CartItem>? response;
  final ApiErrorV1? error;

  GetCartItemsRet({this.response, this.error});
}

class PatchCartParams {
  final String cartItemId;
  final bool qtyInc;

  PatchCartParams({
    required this.cartItemId,
    required this.qtyInc,
  });
}

class PatchCartRet {
  final int? response;
  final ApiErrorV1? error;

  PatchCartRet({
    this.response,
    this.error,
  });
}

class DeleteCartParams {
  final String cartItemId;

  DeleteCartParams({
    required this.cartItemId,
  });
}

class DeleteCartRet {
  final int? response;
  final ApiErrorV1? error;

  DeleteCartRet({
    this.response,
    this.error,
  });
}

class PostCartParams {
  final String restaurantId;
  final String menuItemId;
  final int qty;

  PostCartParams({
    required this.restaurantId,
    required this.menuItemId,
    required this.qty,
  });
}

class PostCartRet {
  final int? response;
  final ApiErrorV1? error;

  PostCartRet({
    this.response,
    this.error,
  });
}

class PostOrderParams {
  final bool pg;
  final String restaurantId;

  PostOrderParams({
    required this.pg,
    required this.restaurantId,
  });
}

class PostOrderRet {
  final NOrder? response;
  final ApiErrorV1? error;

  PostOrderRet({
    this.response,
    this.error
  });
}

class GetOrdersParams {
  final int skip;
  final int limit;

  GetOrdersParams({
    required this.skip,
    required this.limit,
  });
}

class GetOrdersResponse {
  final bool hasMore;
  final List<NOrder> data;

  GetOrdersResponse({
    required this.hasMore,
    required this.data,
  });

  factory GetOrdersResponse.fromJSON(Map<String, dynamic> json) {
    return GetOrdersResponse(
      hasMore: json['has_more'],
      data: (json['data'] as List).map((e) => NOrder.fromJSON(e)).toList(),
    );
  }
}

class GetOrdersRet {
  final GetOrdersResponse? response;
  final ApiErrorV1? error;

  GetOrdersRet({
    this.response,
    this.error,
  });
}
