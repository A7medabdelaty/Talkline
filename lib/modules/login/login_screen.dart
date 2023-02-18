import 'package:chat_app/layout/social_app_layout.dart';
import 'package:chat_app/modules/login/cubit/cubit.dart';
import 'package:chat_app/modules/login/cubit/states.dart';
import 'package:chat_app/modules/register/register_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubit/cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginUserSuccessState) {
            Fluttertoast.showToast(
              msg: 'Login Success',
              backgroundColor: Colors.green,
            );
            AppCubit.get(context).getPosts();
            AppCubit.get(context).getUserData();
            navigateAndReplace(context, const SocialApp());
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Login now to make communication more easier',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultInputField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'email can\'t be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultInputField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          label: 'Password',
                          prefixIcon: Icons.lock,
                          suffixIcon: Icons.visibility,
                          suffixAction: () {
                            cubit.changeVisibility();
                          },
                          obscureText: cubit.isPassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'password can\'t be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: defaultButton(
                                text: 'LOGIN',
                                radius: 5,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                })),
                        Row(
                          children: [
                            const Text('Don\'t have account?'),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: const Text('Register Now'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
