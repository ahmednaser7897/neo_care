import 'package:neo_care/controller/doctor/doctor_state.dart';
import 'package:neo_care/model/baby/babies_model.dart';
import 'package:neo_care/model/hospital/hospital_model.dart';
import 'package:neo_care/model/mother/mother_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neo_care/app/app_assets.dart';
import 'package:neo_care/view/componnents/widgets.dart';
import 'package:neo_care/app/extensions.dart';
import '../../app/app_strings.dart';
import '../../controller/admin/admin_cubit.dart';
import '../../controller/doctor/doctor_cubit.dart';
import '../../controller/hospital/hospital_cubit.dart';
import '../../model/doctor/doctor_model.dart';
import '../../model/admin/admin_model.dart';

import '../admin/admins/admin_details_screen.dart';
import '../hospital/hospitel_details_screen.dart';
import '../doctor/mother/baby/baby_details_screen.dart';
import '../doctor/doctor_details_screen.dart';
import '../mother/mother_details_screen.dart';

Widget buildAdminList(List<AdminModel> admins) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: admins.length,
      itemBuilder: (context, index) {
        return BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {},
          builder: (context, state) {
            return admins.isEmpty
                ? emptListWidget(AppStrings.admins)
                : buildHomeItem(
                    isOnline: admins[index].online.orFalse(),
                    ban: admins[index].ban.orFalse(),
                    name: admins[index].name.orEmpty(),
                    des: admins[index].email.orEmpty(),
                    image: admins[index].image,
                    id: admins[index].id.orEmpty(),
                    assetImage: AppAssets.admin,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDetailsScreen(
                            model: admins[index],
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  });
}

Widget buildHospitalsList(
    {required List<HospitalModel> hospitels, bool canEdit = true}) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: hospitels.length,
      itemBuilder: (context, index) {
        return BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {},
          builder: (context, state) {
            return hospitels.isEmpty
                ? emptListWidget(AppStrings.hospitals)
                : buildHomeItem(
                    isOnline: hospitels[index].online.orFalse(),
                    ban: hospitels[index].ban.orFalse(),
                    name: hospitels[index].name.orEmpty(),
                    des: hospitels[index].email.orEmpty(),
                    id: hospitels[index].id.orEmpty(),
                    image: hospitels[index].image,
                    assetImage: AppAssets.hospital,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HospitelDetailsScreen(
                            model: hospitels[index],
                            //canEdit: canEdit,
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  });
}

Widget buildDoctorsList(
    {required List<DoctorModel> doctors, bool canEdit = true}) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return BlocConsumer<HospitalCubit, HospitalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return doctors.isEmpty
                ? emptListWidget(AppStrings.doctors)
                : buildHomeItem(
                    isOnline: doctors[index].online.orFalse(),
                    ban: doctors[index].ban.orFalse(),
                    name: doctors[index].name.orEmpty(),
                    des: doctors[index].email.orEmpty(),
                    id: doctors[index].id.orEmpty(),
                    image: doctors[index].image,
                    assetImage: AppAssets.doctor,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsScreen(
                            model: doctors[index],
                            //canEdit: canEdit,
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  });
}

Widget buildMothersList(
    {required List<MotherModel> mothers, bool canEdit = true}) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: mothers.length,
      itemBuilder: (context, index) {
        return BlocConsumer<HospitalCubit, HospitalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return mothers.isEmpty
                ? emptListWidget(AppStrings.mothers)
                : buildHomeItem(
                    isOnline: mothers[index].online.orFalse(),
                    leaft: mothers[index].leaft.orFalse(),
                    ban: mothers[index].ban.orFalse(),
                    name: mothers[index].name.orEmpty(),
                    des: mothers[index].email.orEmpty(),
                    id: mothers[index].id.orEmpty(),
                    image: mothers[index].image,
                    assetImage: AppAssets.mother,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MotherDetailsScreen(
                            model: mothers[index],
                            //canEdit: canEdit,
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  });
}

Widget buildBabyList({required List<BabieModel> baby, bool canEdit = true}) {
  return Builder(builder: (context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: baby.length,
      itemBuilder: (context, index) {
        return BlocConsumer<HospitalCubit, HospitalState>(
          listener: (context, state) {},
          builder: (context, state) {
            return baby.isEmpty
                ? emptListWidget(AppStrings.babys)
                : buildHomeItem(
                    isOnline: null,
                    ban: false,
                    leaft: baby[index].left.orFalse(),
                    name: baby[index].name.orEmpty(),
                    des: 'Birth Date : ${baby[index].birthDate.orEmpty()}',
                    id: baby[index].id.orEmpty(),
                    image: baby[index].photo,
                    assetImage: AppAssets.baby,
                    ontap: () async {
                      var value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlocConsumer<DoctorCubit, DoctorState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return BabyDetailsScreen(
                                model: baby[index],
                              );
                            },
                          ),
                        ),
                      );
                      if (value == 'add') {
                        Navigator.pop(context, 'add');
                      }
                    },
                  );
          },
        );
      },
    );
  });
}
