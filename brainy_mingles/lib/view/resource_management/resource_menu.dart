import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:brainy_mingles/view/resource_management/upload_resource.dart';
import 'package:brainy_mingles/view/resource_management/get_resource.dart';
import 'package:brainy_mingles/view/resource_management/get_my_resources.dart';
import 'package:brainy_mingles/const/app_colors.dart';

class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MentorDrawer1(), // Use your custom drawer widget here
      body: Column(
        children: [
          const CustomAppBar(),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      color: AppColor
                          .blueColor, // Set the background color of the TabBar
                      child: TabBar(
                        tabs: [
                          Tab(text: 'Upload'),
                          Tab(text: 'All Material'),
                          Tab(text: 'My Material'),
                        ],
                        indicatorColor: AppColor.whiteColor,
                        labelColor: AppColor.whiteColor,
                        unselectedLabelColor: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          UploadResources(),
                          AllPage(),
                          MyPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadResources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UploadPage();
  }
}

class AllPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AllResourcesPage();
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyResourcesPage();
  }
}
