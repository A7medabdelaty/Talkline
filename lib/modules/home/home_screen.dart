import 'package:chat_app/shared/components/components.dart';
import 'package:chat_app/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../models/post_model/post.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.userModel != null,
            builder: (context) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (!cubit.isPressed &&
                          !FirebaseAuth.instance.currentUser!.emailVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.amber.withOpacity(0.6),
                          child: Row(
                            children: [
                              const Icon(Icons.info),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Yor email is not verified'),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    cubit.changePress();
                                    FirebaseAuth.instance.currentUser
                                        ?.sendEmailVerification()
                                        .then((value) {
                                      cubit.verificationTimer();
                                      Fluttertoast.showToast(
                                          msg: 'Check your mail',
                                          backgroundColor: Colors.green);
                                    }).catchError((error) {
                                      print(error.toString());
                                    });
                                  },
                                  child: const Text('Send Email')),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 7,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  const Image(
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://img.freepik.com/free-photo/horizontal-shot-good-looking-afro-american-woman-feels-very-happy-holds-modern-smartphone-hand-wears-stereo-headphones-points-aside-blank-space-blue-background-leisure-concept_273609-45236.jpg?w=1060&t=st=1661116427~exp=1661117027~hmac=049f26e4377e9e2d7ce5c2ab590234a9815e76d8b068643e5121bb6bde9fbb1d')),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Communicate With Friends',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return buildCardItem(
                                    context, cubit.posts[index], index, cubit);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 5,
                                    ),
                                itemCount: cubit.posts.length),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }
}

Widget buildCardItem(context, PostModel model, index, AppCubit cubit) {
  TextEditingController commentController = TextEditingController();
  TextEditingController commentData = TextEditingController();
  return Card(
    elevation: 7,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '${model.dateTime}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                padding: EdgeInsets.zero,
                splashRadius: 20,
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${model.text}',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: Wrap(
          //     spacing: 3,
          //     children: [
          //       SizedBox(
          //         height: 25,
          //         child: MaterialButton(
          //           height: 10,
          //           onPressed: () {},
          //           minWidth: 1.0,
          //           padding: EdgeInsets.zero,
          //           child: Text(
          //             '#Software',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 ?.copyWith(color: Colors.blue, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 25,
          //         child: MaterialButton(
          //           height: 10,
          //           onPressed: () {},
          //           minWidth: 1.0,
          //           padding: EdgeInsets.zero,
          //           child: Text(
          //             '#Labour Day',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 ?.copyWith(color: Colors.blue, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 25,
          //         child: MaterialButton(
          //           height: 10,
          //           onPressed: () {},
          //           minWidth: 1.0,
          //           padding: EdgeInsets.zero,
          //           child: Text(
          //             '#Flutter',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 ?.copyWith(color: Colors.blue, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 25,
          //         child: MaterialButton(
          //           height: 10,
          //           onPressed: () {},
          //           minWidth: 1.0,
          //           padding: EdgeInsets.zero,
          //           child: Text(
          //             '#Labour_Day',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 ?.copyWith(color: Colors.blue, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 25,
          //         child: MaterialButton(
          //           height: 10,
          //           onPressed: () {},
          //           minWidth: 1.0,
          //           padding: EdgeInsets.zero,
          //           child: Text(
          //             '#Flutter',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 ?.copyWith(color: Colors.blue, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 5,
          ),
          if (model.postImage != '')
            ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 400, minWidth: double.infinity),
                child: Image.network('${model.postImage}', fit: BoxFit.cover)),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${cubit.likes[index]}'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    cubit.getComments(model.postId);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            '${model.image}'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${cubit.comments[index].name}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            TextFormField(
                                              controller: commentData,
                                              readOnly: true,
                                              onFieldSubmitted: (value) =>
                                                  cubit.addComment(
                                                      commentController.text,
                                                      model.postId),
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: 1,
                          separatorBuilder: (context, index) =>
                              mySeparatorBuilder(),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('0 Comment'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          mySeparatorBuilder(),
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage('${cubit.userModel!.image}'),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: commentController,
                      onFieldSubmitted: (value) => cubit.addComment(
                          commentController.text, model.postId),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Write Comment...',
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  cubit.userLikePost(model.postId!);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(IconBroken.Heart),
                      Text('Like'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
