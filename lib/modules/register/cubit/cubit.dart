import 'package:chat_app/models/user_data/users.dart';
import 'package:chat_app/modules/register/cubit/states.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData visibilityIcon = Icons.visibility;

  void changeVisibility() {
    isPassword = !isPassword;
    visibilityIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterChangeVisibilityState());
  }

  void registerUser(
      {required name, required email, required password, required phone}) {
    emit(RegisterUserLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CacheHelper.putData(key: 'uId', value: value.user?.uid);
      emit(RegisterUserSuccessState());
      createUser(name: name, email: email, phone: phone, uId: value.user?.uid);
    }).catchError((error) {
      print(error.toString());
      emit(RegisterUserErrorState());
    });
  }

  void createUser(
      {required name, required email, required phone, required uId}) {
    UserModel model = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        image:
            'https://3znvnpy5ek52a26m01me9p1t-wpengine.netdna-ssl.com/wp-content/uploads/2017/07/noimage_person.png',
        cover:
            'https://img.freepik.com/free-photo/influencer-dancing-posting-social-media_23-2149194124.jpg?w=1380&t=st=1661263954~exp=1661264554~hmac=27ab71dbea7518e2654780ae0dacb51c0ad179def4a13bea3ade32723b49fc0b',
        bio: 'Write Your Bio Here',
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState());
    });
  }
}
