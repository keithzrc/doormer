import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';

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
        return MultiProvider(
          providers: [
            Provider<GetUnarchivedchatList>(
              create: (_) => serviceLocator<GetUnarchivedchatList>(),
            ),
            Provider<GetArchivedList>(
              create: (_) => serviceLocator<GetArchivedList>(),
            ),
            Provider<ToggleChat>(
              create: (_) => serviceLocator<ToggleChat>(),
            ),
            Provider<DeleteChat>(
              create: (_) => serviceLocator<DeleteChat>(),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Helvetica',
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router, // Use GoRouter for navigation
          ),
        );
      },
    );
  }
}
