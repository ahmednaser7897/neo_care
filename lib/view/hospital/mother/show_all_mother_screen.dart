import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../controller/hospital/hospital_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class ShowAllMothersScreen extends StatefulWidget {
  const ShowAllMothersScreen({super.key});

  @override
  State<ShowAllMothersScreen> createState() => _ShowAllMothersScreenState();
}

class _ShowAllMothersScreenState extends State<ShowAllMothersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HospitalCubit, HospitalState>(
      buildWhen: (previous, current) =>
          current is LoadingGetMothers ||
          current is ScGetMothers ||
          current is ErorrGetMothers,
      listener: (context, state) {},
      builder: (context, state) {
        HospitalCubit cubit = HospitalCubit.get(context);
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
              state is LoadingGetHospital ||
              state is LoadingChangeHospitalOnline,
          isSc: state is ScGetMothers || cubit.mothers.isNotEmpty,
        );
      },
    );
  }
}
