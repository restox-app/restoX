import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/user.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  child: CircleAvatar(
                    child: Icon(Icons.account_box, size: 100),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(ref.read(userProvider).user!.displayName!, style: Theme.of(context).textTheme.headlineMedium),
              Text(ref.read(userProvider).user!.email!, style: Theme.of(context).textTheme.labelLarge),
              const Padding(padding: EdgeInsets.all(20)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Orders'),
                      leading: const Icon(Icons.inventory_2_outlined),
                      onTap: () {
                        context.push("/orders");
                      },
                      /* onLongPress: () {
                        ref.read(paymentGatewayProvider.notifier).setVal(!ref.watch(paymentGatewayProvider)!);
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: Text('Payment Gateway ${ref.watch(paymentGatewayProvider) ? 'Enabled': 'Disabled' }'),
                          actions: [
                            ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text('Ok'))
                          ],
                        ));
                      }, */
                    ),
                    ListTile(
                      title: const Text('Sign Out'),
                      leading: const Icon(Icons.logout_outlined),
                      onTap: () {
                        ref.read(userProvider.notifier).signout();
                        context.pop();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
