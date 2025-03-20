// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:neo_care/app/app_prefs.dart';
import 'package:neo_care/view/auth/login_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../auth/widgets/build_auth_bottom.dart';
import 'const_widget.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function onTap;
  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressComponent()
        : BottomComponent(
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              widget.onTap();
              await FirebaseAuth.instance.signOut();
              await OneSignal.logout();
              await AppPreferences.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          );
  }
}
