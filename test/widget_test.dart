import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

const signedInText = 'You are signed in';
const notSignedInText = 'You are not signed in';

class AuthController extends GetxController {
  String? email, password;

  Rx<bool> isSigned = false.obs;

  void signIn(String email, String password) {
    this.email = email;
    this.password = password;
    isSigned.value = true;
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  // int _count = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Column(
      children: [
        Obx(() {
          return Text(
            controller.isSigned.value ? signedInText : notSignedInText,
          );
        }),

        // Text('$_count'),
        FilledButton(
          onPressed: () {
            controller.signIn('collinsxnnanna@gmail.com', 'Password123');
            // setState(() => _count++);
            // print('Button pressed');
          },
          child: Text('Sign in'),
        ),
      ],
    );
  }
}

void main() {
  setUp(() {});

  group('Test AuthController interaction with UI', () {
    testWidgets('Description', (tester) async {
      Get.lazyPut(() => AuthController());

      await tester.pumpWidget(MaterialApp(home: ExampleWidget()));

      expect(find.text(notSignedInText), findsOne);

      await tester.tap(find.byType(ButtonStyleButton));

      await tester.pump();

      expect(find.text(signedInText), findsOne);
    });
  });
}
