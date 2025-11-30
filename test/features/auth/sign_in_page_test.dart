import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/auth/views/sign_in.dart';

void main() {
  group('Sign In Page', () {
    Future<void> pumpSignIn(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInPage()));
      await tester.pumpAndSettle();
    }

    testWidgets('shows tabs and related form fields', (tester) async {
      await pumpSignIn(tester);

      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Full name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsWidgets);
    });

    testWidgets('triggers placeholder actions for buttons', (tester) async {
      await pumpSignIn(tester);

      await tester.tap(find.text('Sign In').last);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create account'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
