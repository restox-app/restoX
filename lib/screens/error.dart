import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Error extends ConsumerWidget {
  const Error({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("This Page doesn't exist", style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back'))
          ],
        ),
      ),
    );
  }
}
