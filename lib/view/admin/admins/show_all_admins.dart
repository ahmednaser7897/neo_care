import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_sized_box.dart';
import '../../../controller/admin/admin_cubit.dart';
import '../../componnents/screen_builder.dart';
import '../../componnents/users_lists.dart';

class ShowAllAdminScreen extends StatefulWidget {
  const ShowAllAdminScreen({super.key});

  @override
  State<ShowAllAdminScreen> createState() => _ShowAllAdminScreenState();
}

class _ShowAllAdminScreenState extends State<ShowAllAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      buildWhen: (previous, current) =>
          current is LoadingGetAdmins ||
          current is ScGetAdmins ||
          current is ErorrGetAdmins,
      listener: (context, state) {},
      builder: (context, state) {
        AdminCubit cubit = AdminCubit.get(context);
        return screenBuilder(
          contant: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAdminList(cubit.admins),
                    AppSizedBox.h2,
                  ],
                ),
              ),
            ),
          ),
          isEmpty: false,
          isErorr: state is ErorrGetAdmins,
          isLoading: state is LoadingGetAdmins,
          isSc: state is ScGetAdmins || cubit.admins.isNotEmpty,
        );
      },
    );
  }
}
