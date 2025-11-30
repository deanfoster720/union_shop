import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _openingHoursSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Opening Hours:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Winter Break Closure Dates', style: TextStyle(fontSize: 14)),
        SizedBox(height: 4),
        Text('Closing 4pm 19/12/2025', style: TextStyle(fontSize: 14)),
        Text('Reopening 10am 05/01/2026', style: TextStyle(fontSize: 14)),
        Text('Last post date: 12pm on 18/12/2025',
            style: TextStyle(fontSize: 14)),
        SizedBox(height: 8),
        Divider(),
        SizedBox(height: 8),
        Text('(Term Time)', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('Monday - Friday 10am - 4pm', style: TextStyle(fontSize: 14)),
        SizedBox(height: 8),
        Text('(Outside of Term Time / Consolidation Weeks)',
            style: TextStyle(fontWeight: FontWeight.w600)),
        Text('Monday - Friday 10am - 3pm', style: TextStyle(fontSize: 14)),
        SizedBox(height: 8),
        Text('Purchase online 24/7', style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _helpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Help and Information:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('Search')),
        TextButton(
            onPressed: () {},
            child: const Text('Terms & Conditions of Sale Policy')),
      ],
    );
  }

  Widget _latestOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest Offers:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Subscribe'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(builder: (context, constraints) {
        final bool wide = constraints.maxWidth > 800;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _openingHoursSection()),
              const SizedBox(width: 24),
              Expanded(child: _helpSection()),
              const SizedBox(width: 24),
              Expanded(child: _latestOffersSection()),
            ],
          );
        }

        // Narrow layout: stack sections vertically
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _openingHoursSection(),
            const SizedBox(height: 16),
            _helpSection(),
            const SizedBox(height: 16),
            _latestOffersSection(),
          ],
        );
      }),
    );
  }
}
