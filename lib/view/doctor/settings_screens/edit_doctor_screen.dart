import 'package:neo_care/app/extensions.dart';
import 'package:neo_care/view/componnents/const_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../app/app_strings.dart';
import '../../../app/app_validation.dart';

import '../../../controller/doctor/doctor_cubit.dart';
import '../../../controller/doctor/doctor_state.dart';
import '../../../model/doctor/doctor_model.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/widgets.dart';

class EditeDoctorScreen extends StatefulWidget {
  const EditeDoctorScreen({super.key});

  @override
  State<EditeDoctorScreen> createState() => _EditeDoctorScreenState();
}

class _EditeDoctorScreenState extends State<EditeDoctorScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? gender;
  @override
  void initState() {
    DoctorCubit cubit = DoctorCubit.get(context);
    if (cubit.model != null) {
      gender = cubit.model!.gender;

      phoneController.text = cubit.model!.phone ?? '';

      nameController.text = cubit.model!.name ?? '';
      passwordController.text = cubit.model!.password ?? '';
      bioController.text = cubit.model!.bio ?? '';
    }
    super.initState();
  }

  //Make sure that something has changed in the data so that it can be updated.
  // Otherwise, the data will not be updated
  bool isDataChanged(BuildContext context) {
    DoctorCubit cubit = DoctorCubit.get(context);
    return ImageCubit.get(context).image != null ||
        cubit.model!.phone != phoneController.text ||
        cubit.model!.name != nameController.text ||
        cubit.model!.password != passwordController.text ||
        cubit.model!.bio != bioController.text ||
        cubit.model!.gender != gender;
  }

  @override
  Widget build(BuildContext context) {
    DoctorCubit cubit = DoctorCubit.get(context);
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.updateUser(AppStrings.doctor)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Builder(builder: (context) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSizedBox.h1,
                      Align(
                          alignment: Alignment.center,
                          child: ImageWidget(
                            init: cubit.model!.image,
                          )),
                      AppSizedBox.h1,
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        hintText: "Enter  name",
                        prefix: Icons.person,
                        validate: (value) {
                          return Validations.normalValidation(value,
                              name: ' name');
                        },
                      ),
                      AppSizedBox.h3,
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        controller: passwordController,
                        hintText: "Enter  password",
                        prefix: Icons.lock,
                        suffix: Icons.visibility,
                        isPassword: true,
                        validate: (value) {
                          return Validations.passwordValidation(value,
                              name: ' password');
                        },
                      ),
                      AppSizedBox.h3,
                      const Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        hintText: "Enter  phone",
                        prefix: Icons.call,
                        validate: (value) {
                          return Validations.mobileValidation(value,
                              name: ' phone');
                        },
                      ),
                      AppSizedBox.h3,
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      genderWidget(
                          initValue: gender,
                          onTap: (String value) {
                            setState(() {
                              gender = value;
                            });
                          }),
                      AppSizedBox.h3,
                      const Text(
                        "Bio",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        keyboardType: TextInputType.text,
                        controller: bioController,
                        hintText: "Enter  bio",
                        prefix: Icons.info_outline,
                        maxLines: 5,
                        validate: (value) {
                          return Validations.normalValidation(value,
                              name: 'bio');
                        },
                      ),
                      AppSizedBox.h3,
                      BlocConsumer<DoctorCubit, DoctorState>(
                        listener: (context, state) {
                          if (state is ScEditDoctor) {
                            showFlutterToast(
                              message:
                                  AppStrings.userUpdated(AppStrings.doctor),
                              toastColor: Colors.green,
                            );
                            Navigator.pop(context);
                          }
                          if (state is ErorrEditDoctor) {
                            showFlutterToast(
                              message: state.error,
                              toastColor: Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          DoctorCubit doctorCubit = DoctorCubit.get(context);
                          return state is LoadingEditDoctor
                              ? const CircularProgressComponent()
                              : BottomComponent(
                                  child: Text(
                                    AppStrings.updateUser(AppStrings.doctor),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    //if you didn't choose gender
                                    if (gender == null) {
                                      showFlutterToast(
                                        message: 'You must add gender',
                                        toastColor: Colors.red,
                                      );
                                      return;
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      //if nothing has changed in the data
                                      if (!isDataChanged(context)) {
                                        showFlutterToast(
                                          message: 'No data changed for now!',
                                          toastColor: Colors.red,
                                        );
                                        print('No data changed for now!');
                                      } else {
                                        doctorCubit.editDoctor(
                                            image:
                                                ImageCubit.get(context).image,
                                            model: DoctorModel(
                                              ban: false,
                                              name: nameController.text,
                                              password: passwordController.text,
                                              phone: phoneController.text,
                                              gender: gender,
                                              email: DoctorCubit.get(context)
                                                  .model!
                                                  .email,
                                              hospitalId:
                                                  DoctorCubit.get(context)
                                                      .model!
                                                      .hospitalId,
                                              bio: bioController.text,
                                              id: DoctorCubit.get(context)
                                                  .model!
                                                  .id,
                                              image: DoctorCubit.get(context)
                                                  .model!
                                                  .image,
                                              online: true,
                                            ));
                                      }
                                    }
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
