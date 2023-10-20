import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/provider/bottom_bar_provider.dart';
import 'package:brainy_mingles/view/home/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BottomBarProvider())
          ],
          builder: (context, child) {
            return MaterialApp(
              title: 'Brainy Mingles',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                scaffoldBackgroundColor: AppColor.whiteColor,
                fontFamily: "Inter",
                useMaterial3: true,
              ),
              home: const HomePageView(),
            );
          }),
    );
  }
}
