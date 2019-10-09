// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';

import 'package:momento/screens/profile_page/profile_page.dart';
import 'package:momento/screens/signin_page/sign_in_page.dart';
import 'package:momento/services/auth_service.dart';
import 'package:provider/provider.dart';
//import 'package:mockito/mockito.dart';
import 'package:momento/main.dart';

//class MockAuthService extends Mock implements AuthBloc {}

void main() {
  Widget makeTestableWidget({Widget child}) {
    return ClipRect(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: child,
      ),
    );
  }

//   testWidgets('email or password is empty, does not sign in',
//       (WidgetTester tester) async {
//     SignInPage signIn = SignInPage();
// //    MockAuthService mockAuth = MockAuthService();

//     await tester.pumpWidget(makeTestableWidget(child: signIn));
// //    final emailFind = find.text('description');
// //    expect(emailFind, findsOneWidget);
//     //await tester.tap(find.text("LOGIN"));
//   });

}
