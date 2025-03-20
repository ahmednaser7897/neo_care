import 'package:neo_care/app/app_strings.dart';
import 'package:neo_care/controller/doctor/doctor_cubit.dart';
import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:neo_care/model/baby/babies_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neo_care/app/app_sized_box.dart';
import 'package:neo_care/app/app_validation.dart';
import 'package:neo_care/app/extensions.dart';

import '../../../../model/mother/mother_model.dart';
import '../../../auth/widgets/build_auth_bottom.dart';
import '../../../componnents/app_textformfiled_widget.dart';
import '../../../componnents/const_widget.dart';
import '../../../componnents/image_picker/image_cubit/image_cubit.dart';
import '../../../componnents/image_picker/image_widget.dart';
import '../../../componnents/show_flutter_toast.dart';
import '../../../componnents/widgets.dart';

class AddBabyScreen extends StatefulWidget {
  const AddBabyScreen({super.key, required this.model});
  final MotherModel model;
  @override
  State<AddBabyScreen> createState() => _AddBabyScreenState();
}

class _AddBabyScreenState extends State<AddBabyScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController docNoatesController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController headCircumferenceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController gestationalAgeController = TextEditingController();
  var deliveryType = ["Natural", "Cesarean"];
  String? delivery;
  var gestationalAge = [
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43
  ];
  int? gestational;
  final _formKey = GlobalKey<FormState>();
  List<int> values = [0, 1, 2];
  int? activity;
  int? appearance;
  int? grimace;
  int? pulse;
  int? respiration;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.addNewUser(AppStrings.baby)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSizedBox.h1,
                    const Align(
                        alignment: Alignment.center, child: ImageWidget()),
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
                    AppSizedBox.h2,
                    const Text(
                      "Height in(cm)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: heightController,
                      prefix: Icons.height,
                      keyboardType: TextInputType.number,
                      hintText: "Enter height",
                      validate: (value) {
                        return Validations.numberValidation(value,
                            name: 'height');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Head circumference in(cm)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: headCircumferenceController,
                      prefix: Icons.h_mobiledata_sharp,
                      keyboardType: TextInputType.number,
                      hintText: "Enter Head circumference",
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'Head circumference');
                      },
                    ),
                    AppSizedBox.h3,
                    const Text(
                      "Weight in(kg)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      controller: weightController,
                      prefix: Icons.monitor_weight_sharp,
                      keyboardType: TextInputType.number,
                      hintText: "Enter weight",
                      validate: (value) {
                        return Validations.numberValidation(value,
                            name: 'weight');
                      },
                    ),
                    AppSizedBox.h2,
                    const Text(
                      "Dirth Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSizedBox.h2,
                    AppTextFormFiledWidget(
                      readOnly: true,
                      controller: dateController,
                      prefix: Icons.date_range,
                      keyboardType: TextInputType.text,
                      hintText: "Enter date",
                      onTap: () async {
                        var value = await showDateEPicker(context);
                        if (value != null) {
                          dateController.text = dateFoemated(value.toString());
                        }
                      },
                      validate: (value) {
                        return Validations.normalValidation(value,
                            name: 'date');
                      },
                    ),
                    AppSizedBox.h3,
                    findDelevaryValue(delivery, 'Delivery Type', (String val) {
                      delivery = val;
                    }),
                    AppSizedBox.h3,
                    findGestationalAgeValue(gestational, 'Gestational age',
                        (int val) {
                      gestational = val;
                    }),
                    AppSizedBox.h3,
                    Row(
                      children: [
                        scoresIcon(context),
                        AppSizedBox.w5,
                        const Text(
                          "APGAR Score !",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.h2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        findAPGARValue(appearance, 'Appearance', (int val) {
                          appearance = val;
                        }),
                        findAPGARValue(pulse, 'Pulse', (int val) {
                          pulse = val;
                        }),
                        findAPGARValue(grimace, 'Grimace', (int val) {
                          grimace = val;
                        }),
                      ],
                    ),
                    AppSizedBox.h1,
                    Row(
                      children: [
                        findAPGARValue(activity, 'Activity', (int val) {
                          activity = val;
                        }),
                        AppSizedBox.w10,
                        AppSizedBox.w7,
                        findAPGARValue(respiration, 'Respiration', (int val) {
                          respiration = val;
                        }),
                      ],
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
                      controller: docNoatesController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter  Doctor notes",
                      maxLines: 5,
                      prefix: Icons.note,
                      validate: (value) {
                        return null;
                      },
                    ),
                    AppSizedBox.h3,
                    BlocConsumer<DoctorCubit, DoctorState>(
                      listener: (context, state) {
                        if (state is ScAddBaby) {
                          showFlutterToast(
                            message: AppStrings.userAdded(AppStrings.baby),
                            toastColor: Colors.green,
                          );
                          Navigator.pop(
                            context,
                          );
                        }
                        if (state is ErorrAddBaby) {
                          showFlutterToast(
                            message: state.error,
                            toastColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        DoctorCubit cubit = DoctorCubit.get(context);
                        return state is LoadingAddBaby
                            ? const CircularProgressComponent()
                            : BottomComponent(
                                child: Text(
                                  AppStrings.addNewUser(AppStrings.baby),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  //if you didn't choose all data for baby
                                  if (delivery == null ||
                                      gestational == null ||
                                      activity == null ||
                                      appearance == null ||
                                      grimace == null ||
                                      pulse == null ||
                                      respiration == null) {
                                    showFlutterToast(
                                      message:
                                          'All child information must be entered first',
                                      toastColor: Colors.red,
                                    );
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    cubit.addBaby(
                                        image: ImageCubit.get(context).image,
                                        motherModel: widget.model,
                                        model: BabieModel(
                                          birthDate: dateController.text,
                                          deliveryType: delivery,
                                          gestationalAge:
                                              gestational.toString(),
                                          activity: activity,
                                          appearance: appearance,
                                          grimace: grimace,
                                          pulse: pulse,
                                          respiration: respiration,
                                          headCircumference:
                                              headCircumferenceController.text,
                                          doctorNotes: docNoatesController.text,
                                          birthLength: heightController.text,
                                          birthWeight: weightController.text,
                                          left: false,
                                          motherId: widget.model.id,
                                          doctorId: widget.model.docyorlId,
                                          name: nameController.text,
                                          photo: null,
                                          id: null,
                                        ));
                                  }
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget findDelevaryValue(
      String? data, String title, Function(String) onchange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppSizedBox.h2,
        Row(
          children: [
            Container(
              width: 90.w,
              height: 5.h,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  hint: const Text(
                    "Select value",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: data,
                  onChanged: (String? value) {
                    if (value != null) {
                      onchange(value);
                      setState(() {
                        data = value;
                      });
                    }
                  },
                  items: deliveryType.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        AppSizedBox.h1,
      ],
    );
  }

  Widget findAPGARValue(int? data, String title, Function(int) onchange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20.w,
          height: 5.h,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              //isExpanded: true,
              disabledHint: Container(),
              value: data,
              onChanged: (int? value) {
                if (value != null) {
                  onchange(value);
                  setState(() {
                    data = value;
                  });
                }
              },
              items: values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        AppSizedBox.h2,
      ],
    );
  }

  Widget findGestationalAgeValue(
      int? data, String title, Function(int) onchange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppSizedBox.h2,
        Row(
          children: [
            Container(
              width: 90.w,
              height: 5.h,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  hint: const Text(
                    "Select value",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: data,
                  onChanged: (int? value) {
                    if (value != null) {
                      onchange(value);
                      setState(() {
                        data = value;
                      });
                    }
                  },
                  items: gestationalAge.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        '$value week',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        AppSizedBox.h1,
      ],
    );
  }
}
