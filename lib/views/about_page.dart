import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to the Union Shop!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'All online purchases are available for delivery or instore collection!',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'Happy shopping!',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'The Union Shop & Reception Team',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
