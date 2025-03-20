import 'package:neo_care/app/app_strings.dart';
import 'package:neo_care/controller/hospital/hospital_cubit.dart';
import 'package:neo_care/controller/mother/mother_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neo_care/app/app_prefs.dart';
import 'package:neo_care/view/admin/admin_main_screen.dart';
import 'package:get/get.dart';
import 'app/style.dart';
import 'controller/admin/admin_cubit.dart';
import 'controller/doctor/doctor_cubit.dart';
import 'view/auth/login_screen.dart';
import 'view/doctor/doctor_main_screen.dart';
import 'view/hospital/hospital_main_screen.dart';
import 'view/mother/moher_main_screen.dart';

class MyApp extends StatelessWidget {
  static late bool isDark;
  static late BuildContext appContext;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HospitalCubit(),
        ),
        BlocProvider(
          create: (context) => AdminCubit(),
        ),
        BlocProvider(
          create: (context) => MotherCubit(),
        ),
        BlocProvider(
          create: (context) => DoctorCubit(),
        )
      ],
      child: Builder(builder: (mycontext) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: ThemeMode.light,
            onGenerateTitle: (context) {
              appContext = mycontext;
              return '';
            },
            home: getInitialRoute());
      }),
    );
  }

  Widget getInitialRoute() {
    //her we check type of user to navigat to his main screen if you loged in brfor
    //else got to logein screen

    Widget widget = const LoginScreen();

    if (AppPreferences.userType == AppStrings.admin) {
      return const AdminHomeScreen();
    }
    if (AppPreferences.userType == AppStrings.hospital) {
      return const HospitalHomeScreen();
    }
    if (AppPreferences.userType == AppStrings.mother) {
      return const MotherHomeScreen();
    }
    if (AppPreferences.userType == AppStrings.doctor) {
      return const DoctorHomeScreen();
    }
    return widget;
  }
}
