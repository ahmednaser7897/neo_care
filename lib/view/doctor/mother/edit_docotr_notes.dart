import 'package:neo_care/app/extensions.dart';
import 'package:neo_care/controller/doctor/doctor_cubit.dart';
import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:neo_care/view/componnents/const_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/app_sized_box.dart';
import '../../../app/app_strings.dart';
import '../../../model/mother/mother_model.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../componnents/app_textformfiled_widget.dart';
import '../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../componnents/show_flutter_toast.dart';

class EditeDoctorNotesScreen extends StatefulWidget {
  const EditeDoctorNotesScreen({super.key, required this.model});
  final MotherModel model;

  @override
  State<EditeDoctorNotesScreen> createState() => _EditeDoctorNotesScreenState();
}

class _EditeDoctorNotesScreenState extends State<EditeDoctorNotesScreen> {
  TextEditingController doctorNotesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late MotherModel model;
  @override
  void initState() {
    model = widget.model;
    doctorNotesController.text = model.doctorNotes ?? '';

    super.initState();
  }

//Make sure that something has changed in the data so that it can be updated.
  // Otherwise, the data will not be updated
  bool isDataChanged(BuildContext context) {
    return model.doctorNotes != doctorNotesController.text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.updateUser(AppStrings.mother)),
        ),
        body: Builder(builder: (context) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizedBox.h1,
                  const Text(
                    "Doctor notes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSizedBox.h2,
                  AppTextFormFiledWidget(
                    keyboardType: TextInputType.text,
                    controller: doctorNotesController,
                    hintText: "Enter  doctor notes",
                    prefix: Icons.note,
                    maxLines: 5,
                    validate: (value) {
                      return null;
                    },
                  ),
                  const Spacer(),
                  BlocConsumer<DoctorCubit, DoctorState>(
                    listener: (context, state) {
                      if (state is ScEditMotherNotes) {
                        showFlutterToast(
                          message: AppStrings.userUpdated(AppStrings.mother),
                          toastColor: Colors.green,
                        );
                        Navigator.pop(context, 'edit');
                      }
                      if (state is ErorrEditMotherNotes) {
                        showFlutterToast(
                          message: state.error,
                          toastColor: Colors.red,
                        );
                      }
                    },
                    builder: (context, state) {
                      DoctorCubit cubit = DoctorCubit.get(context);
                      return state is LoadingEditMotherNotes
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
                                    cubit.editMotherNotes(
                                      motherModel: model,
                                      doctorNote: doctorNotesController.text,
                                    );
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
    );
  }
}
