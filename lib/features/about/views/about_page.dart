import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';
import 'package:union_shop/features/personalisation/views/personalisation_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToHome() {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    return BaseScaffold(
      backgroundColor: Colors.white,
      header: Header(
        onLogoTap: navigateToHome,
        onPlaceholderPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Union Shop!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive ',
                  ),
                  TextSpan(
                    text: 'personalisation service!',
                    style: const TextStyle(
                      color: Color(0xFF4d2963),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PersonalisationPage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'All online purchases are available for delivery or instore collection!',
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.',
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Happy shopping!',
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Union Shop & Reception Team',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
