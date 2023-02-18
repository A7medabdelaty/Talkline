import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/cubit/states.dart';
import 'package:chat_app/models/message_model/message_model.dart';
import 'package:chat_app/models/user_data/users.dart';
import 'package:chat_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/icon_broken.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, required this.model}) : super(key: key);
  final UserModel model;
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(model.uId);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                  elevation: 1.5,
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(model.image!),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        model.name!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (model.uId ==
                                      cubit.messages[index].senderId) {
                                    return sentMessage(cubit.messages[index]);
                                  }
                                  return receivedMessage(cubit.messages[index]);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 5,
                                    ),
                                itemCount: cubit.messages.length),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              cubit.sendMessage(
                                  model.uId, messageController.text);
                              messageController.text = '';
                            },
                            minWidth: 1.0,
                            height: 50,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: const Icon(IconBroken.Send),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget sentMessage(MessageModel messageModel) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              )),
          child: Text(
            messageModel.text.toString(),
            style: const TextStyle(fontSize: 16),
          )),
    );

Widget receivedMessage(messageModel) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.3),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomStart: Radius.circular(10),
          ),
        ),
        child: Text(
          messageModel.text.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
