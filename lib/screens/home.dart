import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restox/providers/user.dart';
import 'package:restox/widgets/login_dialog.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: MobileScanner(
                      // fit: BoxFit.contain,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;
                        for (final barcode in barcodes) {
                          debugPrint('Barcode found! ${barcode.rawValue}');
                          context.push('/restaurant/${barcode.rawValue}');
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Scan QR code to order', style: Theme.of(context).textTheme.titleSmall),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text('You should see a QR code near your table if the restaurant supports ordering via restoX', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                    ),
                    onTap: () {
                      context.push('/restaurant/644a0c8af7aa818edd4c7461');
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Theme.of(context).primaryColor
              ),
              child: Column(
                children: [
                  ref.watch(userProvider).loggedIn ?
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 30,),
                        Text('${ref.watch(userProvider).user?.displayName}', style: Theme.of(context).textTheme.titleLarge?.merge(TextStyle(color: Theme.of(context).secondaryHeaderColor))),
                        const Spacer(),
                        GestureDetector(
                          child: CircleAvatar(
                            child: Icon(Icons.account_box),
                          ),
                          onTap: () {
                            context.push('/profile');
                          },
                        ),
                        const SizedBox(width: 30,),
                      ],
                    ),
                  )
                  :
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 30,),
                        Text('Welcome Guest', style: Theme.of(context).textTheme.titleLarge?.merge(TextStyle(color: Theme.of(context).secondaryHeaderColor))),
                        const Spacer(),
                        /*const CircleAvatar(
                          child: Icon(Icons.account_box),
                        ),*/
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const LoginDialog(),
                            );
                          },
                          icon: Icon(Icons.login),
                          label: Text('Login')
                        ),
                        const SizedBox(width: 30,),
                      ],
                    ),
                  ),
                  Container(height: MediaQuery.of(context).viewPadding.bottom, width: double.infinity)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
