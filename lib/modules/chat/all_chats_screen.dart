import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/models/user_data/users.dart';
import 'package:chat_app/modules/chat/detailed_chat_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/states.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) => chatItem(cubit.allUsers[index],context),
              separatorBuilder: (context, index) => mySeparatorBuilder(),
              itemCount: cubit.allUsers.length),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          condition: true,
        );
      },
    );
  }
}

Widget chatItem(UserModel model, context) {
  return InkWell(
    onTap: () {
      navigateTo(context, ChatScreen( model: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
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
                  ],
                ),
                const SizedBox(
                  height: 3,
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
    ),
  );
}
