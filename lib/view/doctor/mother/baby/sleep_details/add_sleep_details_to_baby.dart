// ignore_for_file: avoid_print

import 'package:neo_care/app/app_strings.dart';
import 'package:neo_care/controller/doctor/doctor_cubit.dart';
import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:neo_care/model/baby/babies_model.dart';
import 'package:neo_care/model/baby/sleep_details_model.dart';
import 'package:neo_care/view/componnents/start_end_time.dart';
import 'package:neo_care/view/componnents/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neo_care/app/app_sized_box.dart';
import 'package:neo_care/app/app_validation.dart';
import 'package:neo_care/app/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_assets.dart';
import '../../../../../app/app_colors.dart';
import '../../../../auth/widgets/build_auth_bottom.dart';
import '../../../../componnents/app_textformfiled_widget.dart';
import '../../../../componnents/const_widget.dart';
import '../../../../componnents/show_flutter_toast.dart';

class AddSleepDetailsScreen extends StatefulWidget {
  const AddSleepDetailsScreen({super.key, required this.model});
  final BabieModel model;
  @override
  State<AddSleepDetailsScreen> createState() => _AddSleepDetailsScreenState();
}

class _AddSleepDetailsScreenState extends State<AddSleepDetailsScreen> {
  TextEditingController notesNoatesController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var sleepTyps = ["Restful", "Slightly restless"];
  String? sleepQuality;
  double totalSleepDuration = 0;
  List<DetailsModel> details = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.addNewUser(AppStrings.sleeps)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total sleeped hours : ${totalSleepDuration.toStringAsFixed(2)} hours',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSizedBox.h2,
                const Text(
                  "Date",
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
                    return Validations.normalValidation(value, name: 'date');
                  },
                ),
                AppSizedBox.h3,
                const Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppSizedBox.h2,
                AppTextFormFiledWidget(
                  controller: notesNoatesController,
                  keyboardType: TextInputType.text,
                  hintText: "Enter Notes",
                  prefix: Icons.note,
                  maxLines: 5,
                  validate: (value) {
                    return null;
                  },
                ),
                AppSizedBox.h3,
                Row(
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 15.w,
                      height: 5.h,
                      child: BottomComponent(
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          await showMyDialog(context);
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
                AppSizedBox.h3,
                showDetails(),
                AppSizedBox.h3,
                BlocConsumer<DoctorCubit, DoctorState>(
                  listener: (context, state) {
                    if (state is ScAddSleepDetails) {
                      showFlutterToast(
                        message: AppStrings.userAdded(AppStrings.sleeps),
                        toastColor: Colors.green,
                      );
                      Navigator.pop(
                        context,
                      );
                    }
                    if (state is ErorrAddSleepDetails) {
                      showFlutterToast(
                        message: state.error,
                        toastColor: Colors.red,
                      );
                    }
                  },
                  builder: (context, state) {
                    DoctorCubit cubit = DoctorCubit.get(context);
                    return state is LoadingAddSleepDetails
                        ? const CircularProgressComponent()
                        : BottomComponent(
                            child: Text(
                              AppStrings.addNewUser(AppStrings.sleeps),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              //if you did not add sleep details
                              if (details.isEmpty) {
                                showFlutterToast(
                                  message: 'add sleep details',
                                  toastColor: Colors.red,
                                );
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                cubit.addSleepDetails(
                                    baby: widget.model,
                                    motherId: widget.model.motherId ?? '',
                                    model: SleepDetailsModel(
                                      totalSleepDuration:
                                          totalSleepDuration.toStringAsFixed(2),
                                      details: details,
                                      childId: widget.model.id ?? '',
                                      date: dateController.text,
                                      notes: notesNoatesController.text,
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
    );
  }

  Widget showDetails() {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        AppAssets.sleeping,
                      ),
                    ),
                    AppSizedBox.w5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details[index].sleepQuality.orEmpty(),
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        AppSizedBox.h1,
                        Row(
                          children: [
                            Text(
                              'From : ${details[index].startTime.orEmpty()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.almarai(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            AppSizedBox.w3,
                            Text(
                              'To : ${details[index].endTime.orEmpty()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.almarai(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              details.remove(details[index]);
                              calcToalSleepDuration();
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outlined,
                            size: 18,
                            color: AppColors.primerColor,
                          )),
                    ),
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: details.length);
  }

  Future<void> showMyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: _formKey2,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                height: 60.h,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sleeping Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.h3,
                    findValue(sleepQuality, 'Sleep Quality', (String val) {
                      setState(() {
                        sleepQuality = val;
                      });
                    }),
                    AppSizedBox.h2,
                    TimesRow(
                      startDateController: startDateController,
                      endDateController: endDateController,
                    ),
                    AppSizedBox.h2,
                    const Spacer(),
                    BottomComponent(
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (sleepQuality == null) {
                          showFlutterToast(
                            message: 'You must add sleep quality',
                            toastColor: Colors.red,
                          );
                          return;
                        }
                        if (_formKey2.currentState!.validate()) {
                          if (startDateController.text.isNotEmpty &&
                              endDateController.text.isNotEmpty) {
                            DetailsModel model = DetailsModel(
                              endTime: endDateController.text,
                              sleepQuality: sleepQuality,
                              startTime: startDateController.text,
                            );
                            setState(() {
                              details.add(model);
                              startDateController.text = '';
                              endDateController.text = '';
                            });
                            calcToalSleepDuration();
                            Navigator.pop(context);
                          } else {
                            showFlutterToast(
                              message: 'add start and end time ',
                              toastColor: Colors.red,
                            );
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
    startDateController.text = '';
    endDateController.text = '';
    sleepQuality = null;
  }

  void calcToalSleepDuration() {
    totalSleepDuration = 0;
    for (var element in details) {
      var start = parseTimeOfDay(element.startTime!);

      var end = parseTimeOfDay(element.endTime!);
      print(start);
      print(end);
      var startvalue = toDouble(start);
      var endvalue = toDouble(end);
      print(startvalue);
      print(endvalue);
      totalSleepDuration += (startvalue - endvalue).abs();
      print('calcToalSleepDuration $totalSleepDuration');
    }
  }

  Widget findValue(String? data, String title, Function(String) onchange) {
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
              width: 60.w,
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
                  items: sleepTyps.map((value) {
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
        AppSizedBox.h2,
      ],
    );
  }
}
