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
      backgroundColor: Colors.white,
      header: Header(
        onLogoTap: navigateToHome,
        onPlaceholderPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The Union Print Shack',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Temporary image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'Assets/personalisation_images/personalised_image.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.image)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Make It Yours at The Union Print Shack',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Want to add a personal touch? We’ve got you covered with heat-pressed customisation on all our clothing. '
                'Swing by the shop - our team’s always happy to help you pick the right gear and answer any questions.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
              ),

              const SizedBox(height: 16),
              const Text(
                'Uni Gear or Your Gear - We’ll Personalise It',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Whether you’re repping your university or putting your own spin on a hoodie you already own, we’ve got you covered. '
                'We can personalise official uni-branded clothing and your own items - just bring them in and let’s get creative!',
                style:
                    TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
              ),

              const SizedBox(height: 16),
              const Text(
                'Simple Pricing, No Surprises',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Customising your gear won’t break the bank - just £3 for one line of text or a small chest logo, and £5 for two lines or a large back logo. '
                'Turnaround time is up to three working days, and we’ll let you know as soon as it’s ready to collect.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
              ),

              const SizedBox(height: 16),
              const Text(
                'Personalisation Terms & Conditions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'We will print your clothing exactly as you have provided it to us, whether online or in person. '
                'We are not responsible for any spelling errors. Please ensure your chosen text is clearly displayed in either capitals or lowercase. '
                'Refunds are not provided for any personalised items.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
              ),

              const SizedBox(height: 20),
              const Text(
                'Ready to Make It Yours?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pop in or get in touch - let’s create something uniquely you with our personalisation service.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
              ),
            ],
          ),
        ),
      ),
      footer: const Footer(),
    );
  }
}
