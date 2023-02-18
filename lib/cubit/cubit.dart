import 'dart:async';
import 'dart:io';

import 'package:chat_app/cubit/states.dart';
import 'package:chat_app/models/message_model/message_model.dart';
import 'package:chat_app/models/post_model/commentModel.dart';
import 'package:chat_app/models/post_model/post.dart';
import 'package:chat_app/modules/chat/all_chats_screen.dart';
import 'package:chat_app/modules/home/home_screen.dart';
import 'package:chat_app/modules/settings/settings_screen.dart';
import 'package:chat_app/modules/users/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_data/users.dart';
import '../shared/components/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      emit(AppGetUserDataSuccessState());
      userModel = UserModel.fromJson(value.data()!);
      checkVerified();
      print(value.data());
    }).catchError((error) {
      emit(AppGetUserDataErrorState());
    });
  }

  bool isPressed = false;

  void changePress() {
    isPressed = true;
    emit(AppChangeVerificationState());
  }

  Timer? timer;

  void verificationTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (_) {
      FirebaseAuth.instance.currentUser?.reload();
      checkVerified();
    });
  }

  checkVerified() {
    if (FirebaseAuth.instance.currentUser!.emailVerified &&
        userModel!.isEmailVerified! == false) {
      userModel?.isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(userModel!.toMap());
      timer?.cancel();
      isPressed = true;
      emit(AppEmailVerifiedSuccessState());
    } else {
      isPressed = false;
      emit(AppChangeVerificationState());
    }
  }

  List<String> titles = ['New Feeds', 'Chats', 'Add Post', 'Users', 'Settings'];

  List<Widget> screens = [
    HomeScreen(),
    AllChatsScreen(),
    Container(),
    const UsersScreen(),
    const SettingsScreen()
  ];

  int currentIndex = 0;

  void changeIndex(index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(AddPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavBarState());
    }
  }

  final ImagePicker picker = ImagePicker();

  File? coverImage;

  Future<void> pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(GetCoverImageSuccessState());
    } else {
      Fluttertoast.showToast(
          msg: 'no image was selected', backgroundColor: Colors.red);
      emit(GetCoverImageErrorState());
    }
  }

  File? profileImage;

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetProfileImageSuccessState());
    } else {
      print('no image was selected');
      emit(GetProfileImageErrorState());
    }
  }

  String coverImageUrl = '';

  Future uploadCoverImage() async {
    emit(UploadCoverImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value.toString();
        coverImage = null;
        emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  String profileImageUrl = '';

  Future uploadProfileImage() async {
    emit(UploadProfileImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value.toString();
        profileImage = null;
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  Future<void> updateUserData(
      {required name, required phone, required bio, cover, profile}) async {
    emit(UpdateUserDataLoadingState());
    UserModel model = UserModel(
        name: name,
        email: userModel!.email,
        phone: phone,
        uId: userModel!.uId,
        image: profileImageUrl.isEmpty ? userModel!.image : profileImageUrl,
        cover: coverImageUrl.isEmpty ? userModel!.cover : coverImageUrl,
        bio: bio,
        isEmailVerified: userModel!.isEmailVerified);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .set(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {});
  }

  File? postImage;

  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPostImageSuccessState());
    } else {
      Fluttertoast.showToast(
          msg: 'no image was selected', backgroundColor: Colors.red);
      emit(GetPostImageErrorState());
    }
  }

  Future createPostWithImage({required text}) async {
    emit(CreatePostLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, postImage: value);
        emit(UploadPostImageSuccessState());
      }).catchError((error) {
        emit(UploadPostImageErrorState());
      });
    }).catchError((error) {
      emit(UploadPostImageErrorState());
    });
  }

  Future<void> createPost({postImage, required text}) async {
    emit(CreatePostLoadingState());
    PostModel model = PostModel(
        name: userModel!.name,
        uId: userModel!.uId,
        image: userModel!.image,
        text: text,
        likesMap: {userModel!.uId: 'false'},
        postImage: postImage ?? '',
        dateTime: DateTime.now().toString(),
        postId: '');

    await FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      model.postId = value.id;
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id)
          .update(model.toMap())
          .then((value) => getPosts());
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void removerPostImage() {
    postImage = null;
    emit(RemovePostImageSuccessState());
  }

  List<PostModel> posts = [];
  List<int> likes = [];
  Map<dynamic, dynamic> userLikes = {};

  void getPosts() {
    posts.clear();
    likes.clear();
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));
        int counter = 0;
        PostModel.fromJson(element.data()).likesMap?.forEach((key, value) {
          if (value == true) {
            counter++;
          }
        });
        likes.add(counter);
      });
      emit(AppGetPostsSuccessState());
    }).catchError((error) {
      emit(AppGetPostsErrorState());
    });
  }

  void getLikes() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      likes.clear();
      value.docs.forEach((element) {
        int counter = 0;
        PostModel.fromJson(element.data()).likesMap?.forEach((key, value) {
          if (key == userModel!.uId) {}
          if (value == true) {
            counter++;
          }
        });
        likes.add(counter);
      });
      emit(AppGetPostsSuccessState());
    }).catchError((error) {
      emit(AppGetPostsErrorState());
    });
  }

  void userLikePost(String id) {
    posts.forEach((element) {
      if (element.postId == id) {
        if (element.likesMap![userModel?.uId] == true) {
          posts.forEach((element) {
            if (element.postId == id) {
              element.likesMap?.addAll({userModel!.uId.toString(): false});
              FirebaseFirestore.instance
                  .collection('posts')
                  .doc(id)
                  .update({'likesMap': element.likesMap}).then(
                      (value) => emit(UpdateSuccess()));
              emit(LikePostSuccessState());
            }
          });
          print('true');
        } else if (element.likesMap![userModel?.uId] == false) {
          posts.forEach((element) {
            if (element.postId == id) {
              element.likesMap?.addAll({userModel!.uId.toString(): true});
              FirebaseFirestore.instance
                  .collection('posts')
                  .doc(id)
                  .update({'likesMap': element.likesMap}).then(
                      (value) => emit(UpdateSuccessFalse()));
              emit(LikePostSuccessState());
            }
          });
        }
      }
    });
    getLikes();
  }

  List<UserModel> allUsers = [];

  void getAllUsers() {
    allUsers.clear();
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (UserModel.fromJson(element.data()).uId != userModel!.uId) {
          allUsers.add(UserModel.fromJson(element.data()));
        }
      });
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {
      emit(AppGetAllUsersErrorState());
    });
  }

  void addComment(text, id) {
    CommentModel model = CommentModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      print(value);
      emit(GetCommentsSuccessState());
    }).catchError((error) {
      emit(GetCommentsErrorState());
    });
  }

  List<CommentModel> comments = [];

  void getComments(id) {
    comments.clear();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        print(comments);
      });
    });
    emit(GetCommentsSuccessState());
  }

  void sendMessage(receiverId, text) {
    MessageModel model = MessageModel(
        text: text,
        receiverId: receiverId,
        senderId: userModel!.uId,
        dateTime: DateTime.now().toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages(receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }
}
