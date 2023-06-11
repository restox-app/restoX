import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restox/providers/order_confirmation.dart';

class OrderConfirmation extends ConsumerStatefulWidget {
  const OrderConfirmation({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  final String restaurantId;

  @override
  ConsumerState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends ConsumerState<OrderConfirmation> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(orderProvider.notifier).placeOrder(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderConfState order = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            order.status == 'loading' ?
            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            )
                :
            order.status == 'failed' ?
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 60)
                :
            const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 60),
            const Padding(padding: EdgeInsets.all(5)),
            Text(order.msg, style: Theme.of(context).textTheme.labelLarge),
            order.status == 'successfull' ? TextButton(onPressed: () {
              context.pop();
              context.push("/orders");
            }, child: const Text('Go To Orders')) : Container()
          ],
        ),
      ),
    );
  }
}
