import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restox/models/error.dart';
import 'package:restox/providers/restaurant.dart';
import 'package:restox/widgets/menu_item.dart';

class RestaurantPage extends ConsumerStatefulWidget {
  const RestaurantPage({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  final String restaurantId;

  @override
  ConsumerState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends ConsumerState<RestaurantPage> {
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).fetchRestaurant(widget.restaurantId);
    ref.read(restaurantProvider.notifier).fetchMenuItems(widget.restaurantId);
    ref.read(restaurantProvider.notifier).fetchCartItems(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(restaurantProvider).restaurant.when(
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text((err as ApiErrorV1).msg, style: Theme.of(context).textTheme.titleMedium),
              Text('ERR_CODE: ${(err).code}', style: Theme.of(context).textTheme.overline),
              const Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                child: const Text('Retry'),
                onPressed: () {
                  ref.read(restaurantProvider.notifier).fetchRestaurant(widget.restaurantId);
                },
              )
            ],
          ),
        ),
        data: (restaurant) => Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.data.name, style: Theme.of(context).textTheme.headlineMedium),
                      SizedBox(height: 20),
                      Text('${restaurant.data.email}', style: Theme.of(context).textTheme.labelLarge),
                      Text('+91 ${restaurant.data.contact}', style: Theme.of(context).textTheme.labelLarge),
                      SizedBox(height: 20),
                      Text(restaurant.data.address.line1, style: Theme.of(context).textTheme.labelMedium),
                      Text(restaurant.data.address.city, style: Theme.of(context).textTheme.labelMedium),
                      Text(restaurant.data.address.state, style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ref.watch(restaurantProvider).menuItems.when(
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text((err as ApiErrorV1).msg, style: Theme.of(context).textTheme.titleMedium),
                        Text('ERR_CODE: ${(err).code}', style: Theme.of(context).textTheme.overline),
                        const Padding(padding: EdgeInsets.all(5)),
                        ElevatedButton(
                          child: const Text('Retry'),
                          onPressed: () {
                            ref.read(restaurantProvider.notifier).fetchMenuItems(widget.restaurantId);
                          },
                        )
                      ],
                    ),
                  ),
                  data: (menuItems) => Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.read(restaurantProvider.notifier).fetchMenuItems(widget.restaurantId);
                      },
                      child: ListView.builder(
                        itemCount: menuItems.data.length,
                        padding: EdgeInsets.only(bottom: 150),
                        itemBuilder: (context, index) {
                          if (index < menuItems.data.length) {
                            return MenuItemWidget(menuItem: menuItems.data[index]);
                          } else {
                            if (menuItems.hasMore) {
                              ref.read(restaurantProvider.notifier).fetchMoreMenuItems(widget.restaurantId);
                              return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                            } else {
                              return Container();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 20,),
                            Text((ref.watch(restaurantProvider).cartItems.valueOrNull ?? []).length.toString() + ' items', style: Theme.of(context).textTheme.labelMedium),
                            Text(' | '),
                            Builder(
                              builder: (context) {
                                var price_arr = (ref.watch(restaurantProvider).cartItems.valueOrNull ?? []).map((e) => e.price * e.qty);

                                var price = price_arr.isEmpty ? 0 : price_arr.reduce((v1, v2) => v1 + v2);

                                return Text(NumberFormat.currency(symbol: '₹').format(price), style: Theme.of(context).textTheme.labelMedium);
                              },
                            ),
                            Spacer(),
                            FilledButton(onPressed: ref.watch(restaurantProvider).cartItems.isLoading ? null : () => context.push('/restaurant/${widget.restaurantId}/cart'), child: const Text('Place Order')),
                            SizedBox(width: 20,),
                          ],
                        ),
                      ),
                      ref.watch(restaurantProvider).cartItems.isLoading ? const LinearProgressIndicator() : Container(),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
