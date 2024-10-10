import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/viewed_prod_provider.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'inner_screens/cat_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/product_details.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/btm_bar.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const FirebaseOptions firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyASkpg3qT0DEjiasGUkJTysHT8vZ4m3Rd8",
      authDomain: "fir-5097b.firebaseapp.com",
      projectId: "fir-5097b",
      storageBucket: "fir-5097b.appspot.com",
      messagingSenderId: "361246833717",
      appId: "1:361246833717:web:f7e03820dbe738f82b457c",
      measurementId: "G-EHB03QCVSJ");
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              home: Scaffold(
                  body: Center(
                child: Text('An error occurred'),
              )),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'grocery app',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: const FetchScreen(),
                  routes: {
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                    ProductDetails.routeName: (ctx) => const ProductDetails(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                    ViewedRecentlyScreen.routeName: (ctx) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                  });
            }),
          );
        });
  }
}
