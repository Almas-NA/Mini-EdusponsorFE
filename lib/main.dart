import 'dart:async';

import 'package:edusponsor/admin/cubits/dashboardcubit/dashboard_cubit.dart';
import 'package:edusponsor/admin/cubits/institutions/allinstitutioncubit/allinstitution_cubit.dart';
import 'package:edusponsor/admin/cubits/institutions/institutioncubit/institutions_cubit.dart';
import 'package:edusponsor/admin/cubits/institutions/institutionstatus/institutionstatus_cubit.dart';
import 'package:edusponsor/admin/cubits/settings/profile/profile_cubit.dart';
import 'package:edusponsor/admin/cubits/sponsors/allsponsorcubit/allsponsorcubit_cubit.dart';
import 'package:edusponsor/admin/cubits/sponsors/sponsorcubit/sponsor_cubit.dart';
import 'package:edusponsor/admin/cubits/sponsors/sponsorstatus/sponsorstatus_cubit.dart';
import 'package:edusponsor/approuter/app_router.dart';
import 'package:edusponsor/global_bloc_observer.dart';
import 'package:edusponsor/institution/cubit/institutedashboardcubit/instdashboardcubit_cubit.dart';
import 'package:edusponsor/institution/cubit/instituteprofilecubit/institutionprofile_cubit.dart';
import 'package:edusponsor/institution/cubit/studentcubit/student_cubit.dart';
import 'package:edusponsor/login/authcubit/user_cubit.dart';
import 'package:edusponsor/login/registercubit/register_cubit.dart';
import 'package:edusponsor/student/cubit/dashboardcubit/studdashboard_cubit.dart';
import 'package:edusponsor/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Init Hive before anything else
      await Hive.initFlutter();
      await Hive.openBox('eduSponsor');

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set bloc observer
      Bloc.observer = GlobalBlocObserver();
      runApp(MyApp(appRouter: AppRouter()));
    },
    (error, stackTrace) {
      // Optional: global error logging
      print("Uncaught zone error: $error");
    },
  );
}

// Decalaring a GlobalKey for showing snackbar
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => InstitutionsCubit()),
        BlocProvider(create: (context) => InstitutionstatusCubit()),
        BlocProvider(create: (context) => AllinstitutionCubit()),
        BlocProvider(create: (context) => SponsorCubit()),
        BlocProvider(create: (context) => SponsorstatusCubit()),
        BlocProvider(create: (context) => AllsponsorcubitCubit()),
        BlocProvider(create: (context) => DashboardCubit()),
        BlocProvider(create: (context) => InstdashboardcubitCubit()),
        BlocProvider(create: (context) => InstitutionprofileCubit()),
        BlocProvider(create: (context) => StudentCubit()),
        BlocProvider(create: (context) => StuddashboardCubit()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.onGenerateRoute,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
      ),
    );
  }
}
