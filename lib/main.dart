import 'package:chat_app/bloc_observer.dart';
import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/layout/social_app_layout.dart';
import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:chat_app/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget myScreen = LoginScreen();

void chooseScreen() {
  uId = CacheHelper.getData(key: 'uId') ?? '';
  if (uId.length > 1) {
    myScreen = const SocialApp();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String? token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print(event.senderId);
    print(event.data);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.senderId);
    print(event.data);
  });

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  chooseScreen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getUserData()
        ..getPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: myScreen,
      ),
    );
  }
}
