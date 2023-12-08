import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/provider/bottom_bar_provider.dart';
import 'package:brainy_mingles/view/sessions_request/session_request.dart';
import 'package:brainy_mingles/view/Bidding/accept-request-bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainHomeViewMentor extends StatefulWidget {
  const MainHomeViewMentor({super.key});

  @override
  State<MainHomeViewMentor> createState() => _MainHomeViewState();
}

List<Widget> pages = [
  // DashboardView(),
  BiddingRequest(),
  //SessionRequest(),
  SessionRequest(),
  SessionRequest(),
  SessionRequest(),
  SessionRequest(),
];

class _MainHomeViewState extends State<MainHomeViewMentor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(
        builder: (context, provider, child) => Scaffold(
              body: pages[provider.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: AppColor.blueColor,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: provider.selectedIndex,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: (value) {
                    provider.updateSelectedIndex(value);
                  },
                  items: [
                    BottomNavigationBarItem(
                        backgroundColor: AppColor.blueColor,
                        icon: Image.asset(
                          "assets/home_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        backgroundColor: AppColor.blueColor,
                        icon: Image.asset(
                          "assets/search_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        backgroundColor: AppColor.blueColor,
                        icon: Image.asset(
                          "assets/session_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        backgroundColor: AppColor.blueColor,
                        icon: Image.asset(
                          "assets/noti_bottom_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        backgroundColor: AppColor.blueColor,
                        icon: Image.asset(
                          "assets/message_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
                        label: ""),
                  ]),
            ));
  }
}
