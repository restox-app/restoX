import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restox/models/error.dart';
import 'package:restox/providers/orders.dart';

class Orders extends ConsumerWidget {
  const Orders({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var resp = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: resp.unwrapPrevious().when(
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
                  ref.refresh(ordersProvider);
                },
              )
            ],
          ),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () async {
            ref.refresh(ordersProvider);
          },
          child: state.orderRes.data.length == 0 ? Center(
            child: Text('No Orders Yet !'),
          ) : ListView.builder(
            itemCount: state.orderRes.data.length + 1,
            itemBuilder: (context, index) {
              if (index < state.orderRes.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text('Order Id'),
                      Text(state.orderRes.data[index].id),
                      SizedBox(height: 20,),
                      Column(
                        children: state.orderRes.data[index].cartItems.map((e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .surface,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network('https://restox-menu-photos.s3.ap-south-1.amazonaws.com/${e.menuItem.image}/medium.jpg'),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.menuItem.name, style: Theme.of(context).textTheme.labelLarge),
                                    Text(NumberFormat.currency(symbol: '₹').format(e.price), style: Theme.of(context).textTheme.labelSmall),
                                  ],
                                ),
                              ),
                            ],
                          )
                        )).toList(),
                      ),
                      SizedBox(height: 20,),
                      Text('Order Status'),
                      Text(state.orderRes.data[index].status),
                      SizedBox(height: 10,),
                      Text('Payment Status'),
                      Text(state.orderRes.data[index].paymentStatus),
                      SizedBox(height: 20,),
                      Divider(),
                    ],
                  ),
                );
              } else {
                if (state.orderRes.hasMore) {
                  ref.read(ordersProvider.notifier).loadMoreOrders();
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
