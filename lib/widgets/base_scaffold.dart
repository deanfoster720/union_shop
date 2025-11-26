import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final Widget? header;
  final Widget? footer;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) header!,
            body,
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}
