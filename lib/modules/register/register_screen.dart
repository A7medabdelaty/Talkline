import 'package:chat_app/modules/home/home_screen.dart';
import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/modules/register/cubit/cubit.dart';
import 'package:chat_app/modules/register/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            Fluttertoast.showToast(msg: 'User Was Created', backgroundColor: Colors.green);
            navigateAndReplace(context, HomeScreen());
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
              appBar: AppBar(title: const Text('Register')),
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
                            'Register',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Register now to make communication more easier',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultInputField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            label: 'Name',
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
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
                            height: 15,
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
                            height: 15,
                          ),
                          defaultInputField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            label: 'Phone',
                            prefixIcon: Icons.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Phone can\'t be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! RegisterUserLoadingState,
                            builder: (BuildContext context) => Center(
                              child: defaultButton(
                                  text: 'Register',
                                  radius: 5,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.registerUser(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text);
                                    }
                                  }),
                            ),
                            fallback: (BuildContext context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
