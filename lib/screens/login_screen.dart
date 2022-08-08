import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

import '../providers/auth_provider.dart';
import '../screens/signup_screen.dart';
import '../screens/products_overview_screen.dart';

class LoginPageScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginPageScreen();

  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  List<FocusNode> focusNode = List<FocusNode>.generate(2, (_) => FocusNode());
  final form = GlobalKey<FormState>();
  Map<String, dynamic> fieldValue = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    super.dispose();

    focusNode = [];
    form.currentState!.dispose();
    fieldValue = {
      'email': '',
      'password': '',
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    height: MediaQuery.of(context).size.height - 44,
                  ),
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 40, bottom: 40),
                          child: const FlutterLogo(
                            size: 140,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 10.0,
                            ),
                            border: OutlineInputBorder(),
                            label: Text('Email'),
                            hintText: 'Email',
                          ),
                          onChanged: (_) {
                            auth.clearError();
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: focusNode[0],
                          onFieldSubmitted: (_) {
                            focusNode[1].requestFocus();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required.';
                            }

                            if (!EmailValidator.validate(value)) {
                              return 'Invalid email address.';
                            }

                            if (auth.error != null &&
                                auth.error['status'] == 400 &&
                                auth.error['type'] == 'email') {
                              return auth.error['message'];
                            }

                            return null;
                          },
                          onSaved: (value) {
                            fieldValue['email'] = value;
                          },
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          focusNode: focusNode[1],
                          onFieldSubmitted: (_) {
                            focusNode[1].unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required.';
                            }

                            if (auth.error != null &&
                                auth.error['status'] == 400 &&
                                auth.error['type'] == 'password') {
                              return auth.error['message'];
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            fieldValue['password'] = value;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 10.0,
                            ),
                            border: OutlineInputBorder(),
                            label: Text(
                              'Password',
                            ),
                            hintText: 'Password',
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 18.0),
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              form.currentState!.save();

                              if (form.currentState!.validate()) {
                                final isSuccess = await auth.login(
                                  email: fieldValue['email'],
                                  password: fieldValue['password'],
                                  loaderOverlay: context.loaderOverlay,
                                );

                                if (isSuccess) {
                                  Toast.show(
                                    'Login successfull!',
                                    gravity: Toast.bottom,
                                    duration: 2,
                                    backgroundColor: Colors.blue,
                                  );

                                  Navigator.of(context).pushReplacementNamed(
                                    ProductsOverviewScreen.routeName,
                                  );
                                }
                              }
                            },
                            child: const Text('LOG IN'),
                          ),
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 64, 63, 63),
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                              SignUpScreen.routeName,
                                            )
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
                        ),
                        const SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
