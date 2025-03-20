import 'package:animate_do/animate_do.dart';
import 'package:neo_care/app/extensions.dart';
import 'package:neo_care/controller/doctor/doctor_cubit.dart';
import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:neo_care/model/baby/babies_model.dart';
import 'package:neo_care/view/doctor/mother/baby/feeding_time/feeding_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/app_assets.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_prefs.dart';
import '../../../../../app/app_sized_box.dart';
import '../../../../../app/app_strings.dart';
import '../../../../../model/baby/feeding_times_model.dart';
import '../../../../componnents/screen_builder.dart';
import 'add_feeding_details_to_baby.dart';

class ShowBabyFeedingDetailss extends StatefulWidget {
  const ShowBabyFeedingDetailss({super.key, required this.model});
  final BabieModel model;
  @override
  State<ShowBabyFeedingDetailss> createState() =>
      _ShowBabyFeedingDetailssState();
}

class _ShowBabyFeedingDetailssState extends State<ShowBabyFeedingDetailss> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Show Baby Feeding details'),
              actions: [
                //doctor can add Feeding details to baby if this doctor is his doctor
                //and if hospital dose not check her out
                if (!widget.model.left.orFalse() &&
                    AppPreferences.userType == AppStrings.doctor &&
                    widget.model.doctorId == DoctorCubit.get(context).model!.id)
                  IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddFeedingDetailsScreen(
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
                            AppSizedBox.h2,
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    feedingDetailsCard(
                                        (widget.model.feedingTimes ??
                                            [])[index]),
                                separatorBuilder: (context, index) =>
                                    AppSizedBox.h2,
                                itemCount:
                                    (widget.model.feedingTimes ?? []).length),
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
                      (widget.model.feedingTimes ?? []).isNotEmpty,
                );
              },
            ));
      },
    );
  }

  Widget feedingDetailsCard(FeedingTimesModel model) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedingsDetailsScreen(
                  model: model,
                ),
              ));
        },
        child: FadeInUp(
          from: 20,
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 500),
          child: Container(
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
                    radius: 30,
                    backgroundImage: AssetImage(
                      AppAssets.feeding,
                    ),
                  ),
                  AppSizedBox.w5,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date : ${model.date.orEmpty()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.almarai(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        AppSizedBox.h1,
                        Text(
                          'Number of feedings : ${model.details.orEmpty().length} ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            fontSize: 13,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSizedBox.h1,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
