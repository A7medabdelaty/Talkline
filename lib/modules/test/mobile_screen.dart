import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';

class MobileScreen extends StatelessWidget {
  MobileScreen({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login Now To The Future',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultInputField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email'),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultInputField(
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Password'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                          defaultButton(text: 'Login', onPressed: () {}, color: Colors.teal)),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child:
                          defaultButton(text: 'Sign Up', onPressed: () {})),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
