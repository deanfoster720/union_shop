import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';

class PrintShackPage extends StatelessWidget {
  const PrintShackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToHome() {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    return BaseScaffold(
      header: Header(
        onLogoTap: navigateToHome,
        onPlaceholderPressed: () {},
      ),
      body: const Center(
        child: Text('The Union Print Shack'),
      ),
      footer: const Footer(),
    );
  }
}
