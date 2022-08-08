import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/user_products.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      child: LoaderOverlay(
        overlayWidth: double.infinity,
        child: Column(
          children: [
            AppBar(
              title: Text('Hello ${auth.user?.email ?? 'user!'} '),
              automaticallyImplyLeading: false,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (ModalRoute.of(context)!.settings.name !=
                    ProductsOverviewScreen.routeName) {
                  Navigator.of(context)
                      .pushReplacementNamed(ProductsOverviewScreen.routeName);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: ListTile(
                leading: const Icon(Icons.shopify),
                title: const Text('Shop'),
                selected: ModalRoute.of(context)!.settings.name ==
                        ProductsOverviewScreen.routeName ||
                    ModalRoute.of(context)!.settings.name == '/',
              ),
            ),
            const Divider(height: 2),
            InkWell(
              onTap: () {
                if (ModalRoute.of(context)!.settings.name !=
                    OrdersScreen.routeName) {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Orders'),
                selected: ModalRoute.of(context)!.settings.name ==
                    OrdersScreen.routeName,
              ),
            ),
            const Divider(height: 2),
            InkWell(
              onTap: () {
                if (ModalRoute.of(context)!.settings.name !=
                    UserProductsScreen.routeName) {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductsScreen.routeName);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Your Products'),
                selected: ModalRoute.of(context)!.settings.name ==
                    UserProductsScreen.routeName,
              ),
            ),
            const Divider(height: 2),
            const Spacer(),
            const Divider(height: 2),
            InkWell(
              onTap: () {
                if (ModalRoute.of(context)!.settings.name !=
                    ProfileScreen.routeName) {
                  Navigator.of(context)
                      .pushReplacementNamed(ProfileScreen.routeName);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: ListTile(
                leading: const Icon(Icons.people_alt_outlined),
                title: const Text('Profile'),
                selected: ModalRoute.of(context)!.settings.name ==
                    ProfileScreen.routeName,
              ),
            ),
            const Divider(height: 2),
            InkWell(
              onTap: () async {
                context.loaderOverlay.show();
                bool isSuccess = await auth.logOut(
                  loaderOverlay: context.loaderOverlay,
                );

                if (isSuccess) {
                  context.loaderOverlay.hide();

                  Navigator.of(context).pushReplacementNamed(
                    LoginPageScreen.routeName,
                  );
                }
              },
              child: const ListTile(
                leading: Icon(Icons.output),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
