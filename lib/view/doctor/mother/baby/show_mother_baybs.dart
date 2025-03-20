import 'package:neo_care/controller/doctor/doctor_cubit.dart';
import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:neo_care/model/mother/mother_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neo_care/app/extensions.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/app_sized_box.dart';
import '../../../../app/app_strings.dart';
import '../../../componnents/screen_builder.dart';
import '../../../componnents/users_lists.dart';
import 'add_baby_to_mother.dart';

class ShowMotherBabys extends StatefulWidget {
  const ShowMotherBabys({super.key, required this.model});
  final MotherModel model;
  @override
  State<ShowMotherBabys> createState() => _ShowMotherBabysState();
}

class _ShowMotherBabysState extends State<ShowMotherBabys> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Show Mother\'s Babies'),
              actions: [
                //doctor can add baby to mother if this doctor is her doctor
                //and if hospital dose not check her out
                if (!widget.model.leaft.orFalse() &&
                    AppPreferences.userType == AppStrings.doctor &&
                    widget.model.docyorlId ==
                        DoctorCubit.get(context).model!.id)
                  IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBabyScreen(
                              model: widget.model,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add))
              ],
            ),
            body: BlocConsumer<DoctorCubit, DoctorState>(
              buildWhen: (previous, current) =>
                  current is LoadingGetMothers ||
                  current is ScGetMothers ||
                  current is ErorrGetMothers,
              listener: (context, state) {},
              builder: (context, state) {
                return screenBuilder(
                  contant: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildBabyList(baby: widget.model.babys ?? []),
                            AppSizedBox.h2,
                          ],
                        ),
                      ),
                    ),
                  ),
                  isEmpty: false,
                  isErorr: state is ErorrGetMothers,
                  isLoading: state is LoadingGetMothers,
                  isSc: state is ScGetMothers ||
                      (widget.model.babys ?? []).isNotEmpty,
                );
              },
            ));
      },
    );
  }
}
