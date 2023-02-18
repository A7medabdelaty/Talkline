import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/cubit/states.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared/styles/icon_broken.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).userModel;
        var cubit = AppCubit.get(context);

        var coverImage = AppCubit.get(context).coverImage;
        var profileImage = AppCubit.get(context).profileImage;

        nameController.text = model!.name.toString();
        bioController.text = model.bio.toString();
        phoneController.text = model.phone.toString();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(IconBroken.Arrow___Left)),
            title: const Text('Edit Profile'),
            actions: [
              TextButton(
                onPressed: () {
                  cubit
                      .updateUserData(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: 'Data Was Updated Successfully',
                        backgroundColor: Colors.green,
                        toastLength: Toast.LENGTH_LONG);
                    Navigator.pop(context);
                  });
                },
                child: const Text('UPDATE'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is UpdateUserDataLoadingState)
                    const LinearProgressIndicator(),
                  if (state is UpdateUserDataLoadingState)
                    const SizedBox(
                      height: 3,
                    ),
                  SizedBox(
                    height: 215,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Image(
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  image: coverImage != null
                                      ? FileImage(coverImage)
                                      : NetworkImage('${model.cover}')
                                          as ImageProvider),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    radius: 16,
                                    child: IconButton(
                                      splashRadius: 10,
                                      onPressed: () {
                                        cubit.pickCoverImage();
                                      },
                                      icon: const Icon(IconBroken.Edit_Square),
                                      iconSize: 16,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 62,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileImage != null
                                      ? FileImage(profileImage)
                                      : NetworkImage('${model.image}')
                                          as ImageProvider,
                                ),
                                CircleAvatar(
                                    radius: 16,
                                    child: IconButton(
                                      splashRadius: 10,
                                      onPressed: () {
                                        cubit.pickProfileImage();
                                      },
                                      icon: const Icon(IconBroken.Edit_Square),
                                      iconSize: 16,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      if (profileImage != null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                  text: 'Upload Profile',
                                  onPressed: () {
                                    cubit.uploadProfileImage();
                                  }),
                              const SizedBox(
                                height: 3,
                              ),
                              if (state is UploadProfileImageLoadingState)
                                const LinearProgressIndicator(),
                            ],
                          ),
                        ),
                      if (profileImage != null && coverImage != null)
                        const SizedBox(
                          width: 8,
                        ),
                      if (coverImage != null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                  text: 'Upload Cover',
                                  onPressed: () {
                                    cubit.uploadCoverImage();
                                  }),
                              const SizedBox(
                                height: 3,
                              ),
                              if (state is UploadCoverImageLoadingState)
                                const LinearProgressIndicator(),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      defaultInputField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        label: 'Name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name must not be empty';
                          }
                          return null;
                        },
                        prefixIcon: IconBroken.User,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultInputField(
                        controller: bioController,
                        keyboardType: TextInputType.text,
                        label: 'Bio',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Bio must not be empty';
                          }
                          return null;
                        },
                        prefixIcon: IconBroken.Info_Circle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultInputField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        label: 'Phone',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Phone must not be empty';
                          }
                          return null;
                        },
                        prefixIcon: IconBroken.Call,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
