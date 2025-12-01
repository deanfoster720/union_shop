import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final Widget? header;
  final Widget? footer;
  final bool scrollable;
  final Color? backgroundColor;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.header,
    this.footer,
    this.scrollable = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) header!,
              Expanded(
                child: scrollable
                    ? SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              body,
                              if (footer != null) footer!,
                            ],
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: body),
                          if (footer != null) footer!,
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
