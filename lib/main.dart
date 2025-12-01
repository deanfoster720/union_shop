import 'package:flutter/material.dart';
import 'package:union_shop/features/about/views/about_page.dart';
import 'package:union_shop/features/auth/views/sign_in.dart';
import 'package:union_shop/features/collections/views/collections_page.dart';
import 'package:union_shop/features/home/views/home_page.dart';
import 'package:union_shop/features/products/views/sales_page.dart';
import 'package:union_shop/features/products/views/shop_page.dart';
import 'package:union_shop/features/about/views/about_print_shack_page.dart';
import 'package:union_shop/features/personalisation/views/personalisation_page.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
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
