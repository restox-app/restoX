import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restox/providers/user.dart';
import 'package:restox/widgets/button_with_linear_loading.dart';

class PasswordResetDialogV1 extends ConsumerStatefulWidget {
  const PasswordResetDialogV1({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PasswordResetDialogV1State();
}

class _PasswordResetDialogV1State extends ConsumerState<PasswordResetDialogV1> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  bool _slide1  = true;

  OpRet? _ret = null;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Form(
        key: _formKey,
        child: AlertDialog(
          title: Row(
            children: const [
              Text('Reset Pass'),
              Spacer(),
              CloseButton(),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(0),
            child: Wrap(
              children: [
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _email = v;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }

                    if (EmailValidator.validate(value) == false) {
                      return 'Please enter Valid Email';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButtonWithLinearLoading(
              child: ElevatedButton(
                child: const Text('Reset'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    OpRet ret = await ref.read(userProvider.notifier).forgotPassword(_email);

                    setState(() {
                      _ret = ret;
                      _slide1 = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      secondChild: _ret != null && _ret!.error != null ? AlertDialog(
        title: Text(_ret!.errorString!),
        actions: [
          ElevatedButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ) : AlertDialog(
        title: const Text('We have sent a password reset link to your email'),
        actions: [
          ElevatedButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      crossFadeState: _slide1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
    );
  }
}
