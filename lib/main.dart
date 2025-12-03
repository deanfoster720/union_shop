import 'package:flutter/material.dart';
import 'package:union_shop/features/about/views/about_page.dart';
import 'package:union_shop/features/auth/views/sign_in.dart';
import 'package:union_shop/features/collections/views/collections_page.dart';
import 'package:union_shop/features/home/views/home_page.dart';
import 'package:union_shop/features/products/views/sales_page.dart';
import 'package:union_shop/features/products/views/shop_page.dart';
import 'package:union_shop/features/about/views/about_print_shack_page.dart';
import 'package:union_shop/features/personalisation/views/personalisation_page.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartService.instance.initialize();
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatefulWidget {
  const UnionShopApp({super.key});

  @override
  State<UnionShopApp> createState() => _UnionShopAppState();
}

class _UnionShopAppState extends State<UnionShopApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Save cart on pause/detached to increase likelihood of persistence
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      CartService.instance.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/': (ctx) => HomeScreen(),
        '/about': (ctx) => const AboutPage(),
        '/print_shack': (ctx) => const PrintShackPage(),
        '/personalisation': (ctx) => const PersonalisationPage(),
        '/shop': (ctx) => ShopPage(),
        '/sign_in': (ctx) => const SignInPage(),
        '/collections': (ctx) => const CollectionsScreen(),
        '/sale': (ctx) => const SalesScreen(),
      },
      initialRoute: '/',
    );
  }
}
