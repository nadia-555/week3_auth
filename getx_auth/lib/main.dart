import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() => runApp(const StudentAuthApp());

class StudentAuthApp extends StatelessWidget {
  const StudentAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام المصادقة الطلابي',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      // حقن التبعيات (Dependency Injection) عبر GetX:
      // الـ Repository ثم الـ Controller الذي يستقبله. permanent = يبقيان طوال عمر التطبيق.
      initialBinding: BindingsBuilder(() {
        Get.put<AuthRepository>(AuthRepositoryImpl(), permanent: true);
        Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
      }),
      home: const LoginPage(),
    );
  }
}
