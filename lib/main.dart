import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依赖
  await initDependencies();

  // // 初始化 SignalR 服务
  // 启动应用
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // 设置设计尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Helvetica',
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router, // 使用 GoRouter 进行导航
        );
      },
    );
  }
}
