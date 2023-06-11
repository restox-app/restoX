import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:restox/providers/user.dart';
import 'package:restox/widgets/button_with_linear_loading.dart';
import 'package:restox/widgets/error_dialog_v1.dart';
import 'package:restox/widgets/password_reset_dialog_v1.dart';

class LoginDialog extends ConsumerStatefulWidget {
  const LoginDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<LoginDialog> {
  final _signFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _name = '';

  bool _isStep1 = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(padding: const EdgeInsets.symmetric(horizontal: 10).add(const EdgeInsets.only(top: 15)), child: const Text('Login')),
      content: AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Form(
            key: _signFormKey, child: Wrap(
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
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }

                    if (EmailValidator.validate(value) == false) {
                      return 'Please enter Valid Email';
                    }
                  }
                ),
                Container(height: 20),
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _password = v;
                    });
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    }

                    if (value.length < 8) {
                      return 'Password too weak';
                    }

                    return null;
                  },
                ),
                Container(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: 'Forgot Password ?',
                        style: Theme.of(context).textTheme.labelSmall?.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            showDialog(context: context, builder: (context) => const PasswordResetDialogV1());
                          }
                    ),
                  ),
                ),
                Container(height: 10),
                ElevatedButtonWithLinearLoading(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_signFormKey.currentState!.validate()) {
                        OpRet ret = await ref.read(userProvider.notifier).signin(_email, _password);

                        if (ret.errorString != null) {

                          if (ret.errorString == 'No User Found for this Email') {
                            setState(() {
                              _isStep1 = false;
                            });
                            return;
                          }

                          if (mounted) {
                            showDialog(
                                context: context,
                                builder: (context) => ErrorDialogV1(errorString: ret.errorString!)
                            );
                            return;
                          }
                        }

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Form(
            key: _nameFormKey,
            child: Wrap(
              children: [
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _name = v;
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^[A-Za-z]+[\s]?[A-Za-z]*$"))
                  ],
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name';
                    }

                    if (RegExp(r"^[A-Za-z]+[\s]?[A-Za-z]*$").hasMatch(value) == false) {
                      return 'Please Enter Valid Name';
                    }

                    return null;
                  },
                ),
                Container(height: 20),
                ElevatedButtonWithLinearLoading(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameFormKey.currentState!.validate()) {
                        OpRet ret = await ref.read(userProvider.notifier).signup(_email, _password, _name);

                        if (ret.errorString != null) {
                          if (mounted) {
                            showDialog(
                                context: context,
                                builder: (context) => ErrorDialogV1(errorString: ret.errorString!)
                            );
                            return;
                          }
                        }

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Signup'),
                  ),
                ),
              ],
            ),
          ),
        ),
        crossFadeState: _isStep1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}

/* class _LoginDialogState extends ConsumerState<LoginDialog> {
  final _phFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();

  bool _loaded = false;
  String _phoneNumber = '';
  dynamic _parsedPhoneNumber;
  String? _phErrText;
  String _otp = '';
  String _name = '';

  Future<bool> validatePhoneNumber() async {
    if (_phFormKey.currentState!.validate()) {
      dynamic ph = await parse('+91$_phoneNumber', region: 'IN');

      setState(() {
        _parsedPhoneNumber = ph;
      });

      if (ph['type'] != 'mobile') {
        setState(() {
          _phErrText = 'You must enter a mobile phone number.';
        });
        return false;
      } else {
        setState(() {
          _phErrText = null;
        });
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    (() async {
      await init();
      setState(() {
        _loaded = true;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: _loaded ? AlertDialog(
        title: Padding(padding: const EdgeInsets.symmetric(horizontal: 10).add(const EdgeInsets.only(top: 15)), child: const Text('Login')),
        content: AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Form(
              key: _phFormKey,
              child: TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LibPhonenumberTextFormatter(country: CountryManager().countries.firstWhere((e) => e.countryCode == 'IN'))
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Phone Number is required';
                  }

                  if (v.length < 10) {
                    return 'Phone Number invalid';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    hintText: '00000 00000',
                    errorText: _phErrText,
                    errorMaxLines: 2
                ),
                onChanged: (v) {
                  setState(() {
                    _phoneNumber = v;
                  });
                },
              ),
            ),
          ),
          secondChild: AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: SizedBox(
                height: 100,
                child: Form(
                  key: _otpFormKey,
                  child: Pinput(
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    length: 6,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'OTP is required';
                      }

                      if (v.length == 6) {
                        return 'OTP should contain 6 chars';
                      }

                      return null;
                    },
                    onChanged: (v) {
                      setState(() {
                        _otp = v;
                      });
                    },
                    onSubmitted: (v) {
                      setState(() {
                        _otp = v;
                      });
                    },
                  ),
                ),
              ),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Form(
                key: _nameFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Name is required';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      _name = v;
                    });
                  },
                ),
              ),
            ),
            crossFadeState: ref.watch(userProvider).requestName ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 500),
          ),
          crossFadeState: ref.watch(userProvider).otpSent ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 500),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              if (!ref.watch(userProvider).otpSent) {
                var valid = await validatePhoneNumber();

                if (valid) {
                  await ref.read(userProvider.notifier).sendOTP(_parsedPhoneNumber['e164']);
                }
              } else if (ref.watch(userProvider).otpSent && !ref.watch(userProvider).requestName) {
                var valid = _otpFormKey.currentState!.validate();

                if (valid) {
                  await ref.read(userProvider.notifier).signUpWithOTP(_otp);
                }
              } else {
                var valid = _nameFormKey.currentState!.validate();

                if (valid) {
                  await ref.read(userProvider.notifier).setDisplayName(_name);
                  await ref.read(userProvider.notifier).authorizeWithServer();
                }
              }
            },
            child: const Text('Continue'),
          )
        ],
      ) : Container(),
      secondChild: Container(),
      crossFadeState: _loaded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
    );
  }
} */
