import 'package:chat_app/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubit/cubit.dart';
import '../../shared/styles/icon_broken.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.removerPostImage();
                },
                icon: const Icon(IconBroken.Arrow___Left_2)),
            title: const Text('Add Post'),
            actions: [
              TextButton(
                  onPressed: () {
                    if (cubit.postImage == null) {
                      cubit.createPost(text: postController.text).then((value) {
                        Fluttertoast.showToast(
                            msg: 'Post Was Created',
                            backgroundColor: Colors.green);
                        cubit.removerPostImage();
                        Navigator.pop(context);
                      });
                    } else {
                      cubit
                          .createPostWithImage(text: postController.text)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: 'Post Was Created',
                            backgroundColor: Colors.green);
                        cubit.removerPostImage();
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('POST'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                if(state is CreatePostLoadingState)
                  const LinearProgressIndicator(),
                if(state is CreatePostLoadingState)
                  const SizedBox(height: 5,),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/front-view-male-student-wearing-black-backpack-holding-copybooks-files-blue-wall_140725-42636.jpg?w=1060&t=st=1661113849~exp=1661114449~hmac=220065d129a997cb2de6fd9dde6c13d800e923091d1725a619f3948324a42001'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Ahmed Abdelaty',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Public',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: TextFormField(
                    controller: postController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Post Can not be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What is in your mind...'),
                    maxLines: 50,
                  ),
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Image(
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          image: FileImage(cubit.postImage!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 16,
                            child: IconButton(
                              splashRadius: 10,
                              onPressed: () {
                                cubit.removerPostImage();
                              },
                              icon: const Icon(IconBroken.Delete),
                              iconSize: 16,
                            )),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            cubit.pickPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(IconBroken.Image),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Add Photos')
                            ],
                          )),
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {}, child: const Text('# tags'))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
