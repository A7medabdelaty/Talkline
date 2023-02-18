import 'dart:io';

import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/cubit/states.dart';
import 'package:chat_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).userModel;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 215,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          image: NetworkImage('${model!.cover}'),),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 62,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage('${model.image}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text(
                    '${model.name}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${model.bio}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: const [
                            Text('Posts'),
                            Text('75'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: const [
                            Text('Posts'),
                            Text('75'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: const [
                            Text('Posts'),
                            Text('75'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: const [
                            Text('Posts'),
                            Text('75'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Add Photos')),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        navigateTo(context, EditProfile());
                      },
                      child: const Icon(IconBroken.Edit),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
