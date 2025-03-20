import 'package:neo_care/app/app_strings.dart';
import 'package:neo_care/model/mother/current_medications_model.dart';
import 'package:flutter/material.dart';
import 'package:neo_care/app/app_sized_box.dart';
import 'package:neo_care/app/extensions.dart';

import '../../../componnents/start_end_date.dart';
import '../../../componnents/widgets.dart';

class MedicationsDetailsScreen extends StatefulWidget {
  const MedicationsDetailsScreen({super.key, required this.model});
  final CurrentMedicationsModel model;
  @override
  State<MedicationsDetailsScreen> createState() =>
      _MedicationsDetailsScreenState();
}

class _MedicationsDetailsScreenState extends State<MedicationsDetailsScreen> {
  late CurrentMedicationsModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.userDetails(AppStrings.medication)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.h1,
              titleAndDescriptionWidget(
                  name: "Name", value: model.name ?? '', prefix: Icons.person),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "purpose",
                  value: model.purpose ?? '',
                  prefix: Icons.add_circle),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "frequency",
                  value: model.frequency.toString(),
                  prefix: Icons.numbers),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "dosage",
                  value: model.dosage ?? '',
                  prefix: Icons.medical_information),
              AppSizedBox.h3,
              DatesRow(
                  isEnable: false,
                  endDateController:
                      TextEditingController(text: model.endDate ?? ''),
                  startDateController:
                      TextEditingController(text: model.startDate ?? '')),
              AppSizedBox.h3,
              titleAndDescriptionWidget(
                  name: "Doctor Notes",
                  value: model.doctorNotes.toString(),
                  prefix: Icons.note),
              AppSizedBox.h3,
            ],
          ),
        ),
      ),
    );
  }
}
