import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restox/api/listings.dart';
import 'package:restox/api/orders.dart';
import 'package:restox/models/menu_item.dart';
import 'package:restox/models/order.dart';
import 'package:restox/models/restaurant.dart';

class RestaurantProviderState {
  final AsyncValue<GetRestaurantResponse> restaurant;
  final AsyncValue<GetMenuItemsResponse> menuItems;
  final AsyncValue<List<CartItem>> cartItems;

  RestaurantProviderState({
    required this.restaurant,
    required this.menuItems,
    required this.cartItems,
  });
}

class RestaurantProviderNotifier
    extends StateNotifier<RestaurantProviderState> {
  RestaurantProviderNotifier(this._ref) : super(RestaurantProviderState(restaurant: AsyncValue.loading(), menuItems: AsyncValue.loading(), cartItems: AsyncValue.loading()));

  final Ref _ref;

  Future<void> fetchRestaurant(String restaurantId) async {
    GetRestaurantRet ret = await getRestaurant(GetRestaurantParams(restaurantId: restaurantId));

    if (ret.error != null) {
      state = RestaurantProviderState(
        restaurant: AsyncValue.error(ret.error!, StackTrace.current),
        menuItems: state.menuItems,
        cartItems: state.cartItems
      );
      return;
    }

    state = RestaurantProviderState(
      restaurant: AsyncValue.data(ret.response!),
      menuItems: state.menuItems,
      cartItems: state.cartItems,
    );
  }

  Future<void> fetchMenuItems(String restaurantId) async {
    GetMenuItemsRet ret = await getMenuItems(GetMenuItemsParams(restaurantId: restaurantId, skip: 0, limit: 10));

    if (ret.error != null) {
      state = RestaurantProviderState(
        menuItems: AsyncValue.error(ret.error!, StackTrace.current),
        restaurant: state.restaurant,
        cartItems: state.cartItems,
      );
      return;
    }

    state = RestaurantProviderState(
      menuItems: AsyncValue.data(ret.response!),
      restaurant: state.restaurant,
      cartItems: state.cartItems
    );
  }

  Future<void> fetchMoreMenuItems(String restaurantId) async {
    GetMenuItemsRet ret = await getMenuItems(GetMenuItemsParams(restaurantId: restaurantId, skip: state.menuItems.value!.data.length, limit: 10));

    if (ret.error != null) {
      state = RestaurantProviderState(
        menuItems: AsyncValue.error(ret.error!, StackTrace.current),
        restaurant: state.restaurant,
        cartItems: state.cartItems
      );
      return;
    }

    state = RestaurantProviderState(
      menuItems: AsyncValue.data(GetMenuItemsResponse(
        hasMore: ret.response!.hasMore,
        data: [
          ...state.menuItems.value!.data,
          ...ret.response!.data,
        ],
      )),
      restaurant: state.restaurant,
      cartItems: state.cartItems
    );
  }

  Future<void> fetchCartItems(String restaurantId) async {
    GetCartItemsRet ret = await getCartItems(GetCartItemsParams(restaurantId: restaurantId));

    if (ret.error != null) {
      state = RestaurantProviderState(
        restaurant: state.restaurant,
        menuItems: state.menuItems,
        cartItems: AsyncValue.error(ret.error!, StackTrace.current),
      );
      return;
    }

    state = RestaurantProviderState(
      restaurant: state.restaurant,
      menuItems: state.menuItems,
      cartItems: AsyncValue.data(ret.response!),
    );
  }

  Future<void> decrementQty(String restaurantId, String cartItemId) async {
    state = RestaurantProviderState(
      restaurant: state.restaurant,
      menuItems: state.menuItems,
      cartItems: const AsyncValue.loading(),
    );

    var ret = await patchCart(PatchCartParams(cartItemId: cartItemId, qtyInc: false));

    if (ret.error == null) {
      await fetchCartItems(restaurantId);
    }
  }

  Future<void> incrementQty(String restaurantId, String cartItemId) async {
    state = RestaurantProviderState(
      restaurant: state.restaurant,
      menuItems: state.menuItems,
      cartItems: const AsyncValue.loading(),
    );

    var ret = await patchCart(PatchCartParams(cartItemId: cartItemId, qtyInc: true));

    if (ret.error == null) {
      await fetchCartItems(restaurantId);
    }
  }

  Future<void> addCartItem(String restaurantId, String menuItemId) async {
    state = RestaurantProviderState(
      restaurant: state.restaurant,
      menuItems: state.menuItems,
      cartItems: const AsyncValue.loading(),
    );

    var ret = await postCart(PostCartParams(
      restaurantId: restaurantId,
      menuItemId: menuItemId,
      qty: 1,
    ));

    if (ret.error == null) {
      await fetchCartItems(restaurantId);
    }
  }

  Future<void> deleteCartItem(String restaurantId, String cartItemId) async {
    state = RestaurantProviderState(
      restaurant: state.restaurant,
      menuItems: state.menuItems,
      cartItems: const AsyncValue.loading(),
    );

    var ret = await deleteCart(DeleteCartParams(cartItemId: cartItemId));

    if (ret.error == null) {
      await fetchCartItems(restaurantId);
    }
  }
}

final restaurantProvider = StateNotifierProvider<RestaurantProviderNotifier, RestaurantProviderState>((ref) {
  return RestaurantProviderNotifier(ref);
});
