import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './providers/auth_provider.dart';
import './providers/product_provider.dart';
import './providers/cart_item_provider.dart';
import './providers/orders_provider.dart';

import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/single_product_screen.dart';
import './screens/cart_item_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products.dart';
import './screens/edit_products.dart';
import './screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider(null),
          update: (_, auth, product) => ProductProvider(auth.user),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(null),
          update: (_, auth, product) => CartProvider(auth.user),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(null),
          update: (_, auth, product) => OrderProvider(auth.user),
        ),
      ],
      child: MaterialApp(
        title: 'Shopify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          LoginPageScreen.routeName: (_) => const LoginPageScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
          SignUpScreen.routeName: (_) => const SignUpScreen(),
          ProductsOverviewScreen.routeName: (_) =>
              const ProductsOverviewScreen(),
          SingleProductScreen.routeName: (_) => const SingleProductScreen(),
          CartItemScreen.routeName: (_) => CartItemScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
          UserProductsScreen.routeName: (_) => const UserProductsScreen(),
          EditProductScreen.routeName: (_) => const EditProductScreen()
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const LoginPageScreen();
            }

            Provider.of<AuthProvider>(context).setUser(snapshot.data);

            return const ProductsOverviewScreen();
          },
        ),
      ),
    );
  }
}
