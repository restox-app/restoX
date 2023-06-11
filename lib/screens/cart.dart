import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restox/models/error.dart';
import 'package:restox/providers/restaurant.dart';
import 'package:restox/widgets/menu_item.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  final String restaurantId;

  @override
  ConsumerState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).fetchCartItems(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    var restaurant = ref.watch(restaurantProvider).restaurant.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.data.name),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              ref.watch(restaurantProvider).cartItems.when(
                loading: () => const Center(
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
                          ref.read(restaurantProvider.notifier).fetchCartItems(widget.restaurantId);
                        },
                      )
                    ],
                  ),
                ),
                data: (listings) => Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.read(restaurantProvider.notifier).fetchCartItems(widget.restaurantId);
                    },
                    child: ListView.builder(
                      itemCount: listings.length,
                      padding: EdgeInsets.only(bottom: 150),
                      itemBuilder: (context, index) {
                        return MenuItemWidget(menuItem: listings[index].menuItem);
                      },
                    ),
                  ),
                ),
              ),
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
                    color: Theme.of(context).primaryColorLight,
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
                          FilledButton(
                              onPressed: ref.watch(restaurantProvider).cartItems.isLoading ? null : () {
                                showDialog(context: context, builder: (c) => AlertDialog(
                                  title: const Text('Are you Sure?'),
                                  content: const Text('This is an irreversible process !'),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(c);
                                    }, child: const Text('No')),
                                    ElevatedButton(onPressed: () {
                                      Navigator.pop(c);
                                      context.push("/restaurant/${widget.restaurantId}/order_conf");
                                    }, child: const Text('Yes')),
                                  ],
                                ));
                              },
                              child: const Text('Make Payment')
                          ),
                          SizedBox(width: 20,),
                        ],
                      ),
                    ),
                    ref.watch(restaurantProvider).cartItems.isLoading ? LinearProgressIndicator() : Container(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
