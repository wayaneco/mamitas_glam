import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<FocusNode> focusNode = List<FocusNode>.generate(5, (_) => FocusNode());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Map<String, dynamic> fieldValues = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
  };
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _formKey.currentState!.dispose();

    passwordController.dispose();
    focusNode = [];
    fieldValues = {
      'firstName': '',
      'lastName': '',
      'email': '',
      'password': '',
      'confirmPassword': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.blue),
    );
    ToastContext().init(context);

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentScope = FocusScope.of(context);

          if (!currentScope.hasPrimaryFocus) {
            currentScope.unfocus();
          }
        },
        child: SafeArea(
          child: LoaderOverlay(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SizedBox(
                height: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          10.0,
                        ),
                        child: ListView(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 40, bottom: 40),
                              child: const FlutterLogo(
                                size: 140,
                              ),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (_) {
                                focusNode[1].requestFocus();
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: focusNode[0],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                fieldValues['firstName'] = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                hintText: 'First Name',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 18.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (_) {
                                focusNode[2].requestFocus();
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: focusNode[1],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                fieldValues['lastName'] = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Last Name',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 18.0),
                            TextFormField(
                              onChanged: (_) {
                                auth.clearError();
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) {
                                focusNode[3].requestFocus();
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: focusNode[2],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required.';
                                }

                                if (!EmailValidator.validate(value)) {
                                  return 'The email is not valid.';
                                }

                                if (auth.error != null &&
                                    auth.error['status'] == 400 &&
                                    auth.error['type'] == 'email') {
                                  return auth.error['message'];
                                }

                                return null;
                              },
                              onSaved: (value) {
                                fieldValues['email'] = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Email',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                passwordController.text = value;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: focusNode[3],
                              keyboardType: TextInputType.visiblePassword,
                              onFieldSubmitted: (_) {
                                focusNode[4].requestFocus();
                              },
                              // initialValue: '',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required.';
                                }

                                if (value.length < 6) {
                                  return 'Password must at least 6 or more characters.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                fieldValues['password'] = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Password',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              onFieldSubmitted: (_) {
                                focusNode[4].unfocus();
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: focusNode[4],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required.';
                                }

                                if (value.length < 6) {
                                  return 'Password must atleast 6 or more characters.';
                                }

                                if (passwordController.text != value) {
                                  return 'Password does not match!';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                fieldValues['confirmPassword'] = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Confirm Password',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 18.0),
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  _formKey.currentState!.save();

                                  if (_formKey.currentState!.validate()) {
                                    final isSuccess =
                                        await auth.registerAccount(
                                      firstName: fieldValues['firstName'],
                                      lastName: fieldValues['lastName'],
                                      email: fieldValues['email'],
                                      password: fieldValues['password'],
                                      loaderOverlay: context.loaderOverlay,
                                    );

                                    if (isSuccess) {
                                      _formKey.currentState!.reset();
                                      passwordController.clear();

                                      FocusScope.of(context).unfocus();

                                      Toast.show(
                                        'Registered! You can now login.',
                                        backgroundColor: Colors.blue,
                                        webShowClose: true,
                                        gravity: Toast.bottom,
                                        duration: 5,
                                      );
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        LoginPageScreen.routeName,
                                      );
                                    }
                                  }
                                },
                                child: const Text('SIGN UP'),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 64, 63, 63),
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      LoginPageScreen.routeName)
                                            },
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
