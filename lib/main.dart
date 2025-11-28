import 'package:flutter/material.dart';
import 'package:union_shop/views/home_page.dart';
import 'package:union_shop/views/about_page.dart';
import 'package:union_shop/views/collections_page.dart';

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
      // Register app routes so pages like About are reachable by name
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/about': (ctx) => const AboutPage(),
        '/collections': (ctx) => const CollectionsScreen(),
      },
      initialRoute: '/',
    );
  }
}
