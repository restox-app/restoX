import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restox/models/menu_item.dart';
import 'package:restox/models/order.dart';
import 'package:restox/providers/restaurant.dart';

class MenuItemWidget extends ConsumerStatefulWidget {
  const MenuItemWidget({
    Key? key,
    required this.menuItem,
  }) : super(key: key);

  final MenuItem menuItem;

  @override
  ConsumerState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends ConsumerState<MenuItemWidget> {
  @override
  Widget build(BuildContext context) {
    var d = (ref.watch(restaurantProvider).cartItems.valueOrNull ?? []);

    CartItem? v;

    d.forEach((element) {
      if (element.menuItemId == widget.menuItem.id) {
        v = element;
      }
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              child: Image.network('https://restox-menu-photos.s3.ap-south-1.amazonaws.com/${widget.menuItem.image}/medium.jpg'),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.menuItem.name, style: Theme.of(context).textTheme.labelLarge),
                Text(NumberFormat.currency(symbol: '₹').format(widget.menuItem.price), style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          const Spacer(),
          ButtonBar(
            children: [
              (v?.qty ?? 0) == 0 ?
              ElevatedButton.icon(
                  onPressed: ref.watch(restaurantProvider).cartItems.isLoading ? null : () {
                    ref.read(restaurantProvider.notifier).addCartItem(widget.menuItem.restaurantId, widget.menuItem.id);
                  },
                  label: const Text('Add'),
                  icon: Icon(Icons.add)
              )
                  :
              Row(
                children: [
                  v!.qty < 2 ?
                  FloatingActionButton.small(
                      onPressed: () {
                        ref.read(restaurantProvider.notifier).deleteCartItem(widget.menuItem.restaurantId, v!.id);
                      },
                      child: Icon(Icons.remove),
                      elevation: 2
                  )
                      :
                  FloatingActionButton.small(
                      onPressed: () {
                        ref.read(restaurantProvider.notifier).decrementQty(widget.menuItem.restaurantId, v!.id);
                      },
                      child: Icon(Icons.remove),
                      elevation: 2
                  ),
                  Container(
                    width: 30,
                    child: Text(v!.qty.toString(), textAlign: TextAlign.center),
                  ),
                  FloatingActionButton.small(
                      onPressed: () {
                        ref.read(restaurantProvider.notifier).incrementQty(widget.menuItem.restaurantId, v!.id);
                      },
                      child: Icon(Icons.add),
                      elevation: 2
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
