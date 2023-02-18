import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/modules/login/cubit/states.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData eyeIcon = Icons.visibility;

  void changeVisibility() {
    isPassword = !isPassword;
    eyeIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(LoginChangeVisibilityState());
  }

  void userLogin({required email, required password}) {
    emit(LoginUserLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CacheHelper.putData(key: 'uId', value: value.user?.uid);
      uId = value.user!.uid;
      emit(LoginUserSuccessState());
    }).catchError((error) {
      emit(LoginUserErrorState());
    });
  }
}
