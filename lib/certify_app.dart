import 'package:certify/%20bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'certify_routes.dart';

class CertifyApp extends StatelessWidget {
  const CertifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: CertifyRoutes.getRoutes(),
      initialRoute: CertifyRoutes.home,
      initialBinding: CertifyBindings(),
    );
  }
}
