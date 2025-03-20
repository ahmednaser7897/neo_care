import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../controller/doctor/doctor_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class ShowALLDoctorMothersScreen extends StatefulWidget {
  const ShowALLDoctorMothersScreen({super.key});

  @override
  State<ShowALLDoctorMothersScreen> createState() =>
      _ShowALLDoctorMothersScreenState();
}

class _ShowALLDoctorMothersScreenState
    extends State<ShowALLDoctorMothersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      buildWhen: (previous, current) =>
          current is LoadingGetMothers ||
          current is ScGetMothers ||
          current is ErorrGetMothers,
      listener: (context, state) {},
      builder: (context, state) {
        DoctorCubit cubit = DoctorCubit.get(context);
        return screenBuilder(
          contant: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildMothersList(mothers: cubit.mothers),
                    AppSizedBox.h2,
                  ],
                ),
              ),
            ),
          ),
          isEmpty: false,
          isErorr: state is ErorrGetMothers,
          isLoading: state is LoadingGetMothers ||
              state is LoadingGetDoctor ||
              state is LoadingChangeDoctorOnline,
          isSc: state is ScGetMothers || cubit.mothers.isNotEmpty,
        );
      },
    );
  }
}
