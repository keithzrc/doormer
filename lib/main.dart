import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/core/routes/app_router.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await initDependencies();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690), // Set base design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              // Provide the GlobalSessionBloc for session state management
              BlocProvider(create: (_) => serviceLocator<GlobalSessionBloc>()),
            ],
            child: ScreenUtilInit(
              designSize: const Size(360, 690), // Set the base design size
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, __) {
                return BlocListener<GlobalSessionBloc, GlobalSessionState>(
                  listener: (context, state) {
                    if (state is SessionExpiredState) {
                      AppRouter.router.go('/auth');
                    }
                  },
                  child: MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Helvetica',
                      useMaterial3: true,
                    ),
                    routerConfig:
                        AppRouter.router, // Use WebRouter as the router
                  ),
                );
              },
            ),
          );
        });
  }
}
