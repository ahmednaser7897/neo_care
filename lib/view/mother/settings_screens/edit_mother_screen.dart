import 'package:neo_care/app/extensions.dart';
import 'package:neo_care/controller/mother/mother_state.dart';
import 'package:neo_care/view/componnents/const_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/app_sized_box.dart';
import '../../../app/app_strings.dart';
import '../../../app/app_validation.dart';
import '../../../app/constants.dart';
import '../../../controller/mother/mother_cubit.dart';
import '../../../model/mother/mother_model.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/image_picker/image_widget.dart';
import '../../componnents/show_flutter_toast.dart';
import '../../componnents/widgets.dart';

class EditeMotherScreen extends StatefulWidget {
  const EditeMotherScreen({super.key});

  @override
  State<EditeMotherScreen> createState() => _EditeMotherScreenState();
}

class _EditeMotherScreenState extends State<EditeMotherScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController doctorNotesController = TextEditingController();
  TextEditingController motherNotesController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> motherHealthyHistory = [];
  List<String> motherPostpartumHealth = [];

  @override
  void initState() {
    MotherCubit cubit = MotherCubit.get(context);
    if (cubit.model != null) {
      motherHealthyHistory.addAll(cubit.model!.healthyHistory ?? []);
      motherPostpartumHealth.addAll(cubit.model!.postpartumHealth ?? []);
      phoneController.text = cubit.model!.phone ?? '';

      addressController.text = cubit.model!.address ?? '';
      doctorNotesController.text = cubit.model!.doctorNotes ?? '';
      motherNotesController.text = cubit.model!.motherNotes ?? '';

      nameController.text = cubit.model!.name ?? '';
      passwordController.text = cubit.model!.password ?? '';
    }
    super.initState();
  }

//Make sure that something has changed in the data so that it can be updated.
  // Otherwise, the data will not be updated
  bool isDataChanged(BuildContext context) {
    MotherCubit cubit = MotherCubit.get(context);
    return ImageCubit.get(context).image != null ||
        cubit.model!.phone != phoneController.text ||
        cubit.model!.name != nameController.text ||
        cubit.model!.address != addressController.text ||
        cubit.model!.doctorNotes != doctorNotesController.text ||
        cubit.model!.motherNotes != motherNotesController.text ||
        cubit.model!.password != passwordController.text ||
        !(Set.from(motherHealthyHistory)
                .difference(Set.from(cubit.model!.healthyHistory ?? []))
                .isEmpty &&
            Set.from(cubit.model!.healthyHistory ?? [])
                .difference(Set.from(motherHealthyHistory))
                .isEmpty) ||
        !(Set.from(motherPostpartumHealth)
                .difference(Set.from(cubit.model!.postpartumHealth ?? []))
                .isEmpty &&
            Set.from(cubit.model!.postpartumHealth ?? [])
                .difference(Set.from(motherPostpartumHealth))
                .isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    MotherCubit cubit = MotherCubit.get(context);
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.updateUser(AppStrings.mother)),
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
                        "Healthy History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h1,
                      selectMultiItemsFromList(
                          healthyHistory, motherHealthyHistory),
                      AppSizedBox.h3,
                      const Text(
                        "Postpartum Health",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h1,
                      selectMultiItemsFromList(
                          postpartumHealth, motherPostpartumHealth),
                      AppSizedBox.h3,
                      const Text(
                        "address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        hintText: "Enter  address",
                        prefix: Icons.home,
                        validate: (value) {
                          return Validations.normalValidation(value,
                              name: ' address');
                        },
                      ),
                      AppSizedBox.h3,
                      const Text(
                        "Mother Note",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        keyboardType: TextInputType.text,
                        controller: motherNotesController,
                        hintText: "Enter mother notes",
                        prefix: Icons.note,
                        maxLines: 5,
                        validate: (value) {
                          return null;
                        },
                      ),
                      AppSizedBox.h3,
                      const Text(
                        "Doctor notes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSizedBox.h2,
                      AppTextFormFiledWidget(
                        isEnable: false,
                        keyboardType: TextInputType.text,
                        controller: doctorNotesController,
                        hintText: "Enter  doctor notes",
                        prefix: Icons.note,
                        maxLines: 5,
                        validate: (value) {
                          return null;
                        },
                      ),
                      AppSizedBox.h3,
                      BlocConsumer<MotherCubit, MotherState>(
                        listener: (context, state) {
                          if (state is ScEditMother) {
                            showFlutterToast(
                              message:
                                  AppStrings.userUpdated(AppStrings.mother),
                              toastColor: Colors.green,
                            );
                            Navigator.pop(context);
                          }
                          if (state is ErorrEditMother) {
                            showFlutterToast(
                              message: state.error,
                              toastColor: Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          MotherCubit motherCubit = MotherCubit.get(context);
                          return state is LoadingEditMother
                              ? const CircularProgressComponent()
                              : BottomComponent(
                                  child: Text(
                                    AppStrings.updateUser(AppStrings.mother),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    //if you didn't choose all data
                                    // if (motherHealthyHistory.isEmpty ||
                                    //     motherPostpartumHealth.isEmpty) {
                                    //   showFlutterToast(
                                    //     message: 'You must add all mother data',
                                    //     toastColor: Colors.red,
                                    //   );
                                    //   return;
                                    // }
                                    if (_formKey.currentState!.validate()) {
                                      //if nothing has changed in the data
                                      if (!isDataChanged(context)) {
                                        showFlutterToast(
                                          message: 'No data changed for now!',
                                          toastColor: Colors.red,
                                        );
                                        print('No data changed for now!');
                                      } else {
                                        motherCubit.editMother(
                                            image:
                                                ImageCubit.get(context).image,
                                            model: MotherModel(
                                              ban: false,
                                              name: nameController.text,
                                              password: passwordController.text,
                                              phone: phoneController.text,
                                              address: addressController.text,
                                              doctorNotes:
                                                  doctorNotesController.text,
                                              motherNotes:
                                                  motherNotesController.text,
                                              healthyHistory:
                                                  motherHealthyHistory,
                                              postpartumHealth:
                                                  motherPostpartumHealth,
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
