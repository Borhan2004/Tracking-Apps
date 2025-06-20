import 'package:chrismiche/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import 'core/utils/theme/theme.dart';

class Chrismiche extends StatelessWidget {
  const Chrismiche({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoute.getSplashScreen(),
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          builder: (context, widget) {
            return EasyLoading.init()(context, widget);
          },
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        );
      },
    );
  }
}
