import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:brainy_mingles/view/resource_management/view_myfiles.dart';
import 'package:brainy_mingles/view/resource_management/view_mylinks.dart';

class MyResourcesPage extends StatefulWidget {
  const MyResourcesPage({super.key});

  @override
  State<MyResourcesPage> createState() => _MyResourcesPageState();
}

class _MyResourcesPageState extends State<MyResourcesPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: AppColor.whiteColor,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_drive_file), // File icon
                      SizedBox(
                          width: 5), // Add some space between icon and text
                      Text('My Files'), // File text
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.link), // Link icon
                      SizedBox(
                          width: 5), // Add some space between icon and text
                      Text('My Links'), // Link text
                    ],
                  ),
                ),
              ],
              indicatorColor: AppColor.blueColor,
              labelColor: AppColor.blueColor,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _selectedIndex == 0 ? ViewFileTab() : ViewLinkTab(),
            _selectedIndex == 1 ? ViewLinkTab() : ViewFileTab(),
          ],
        ),
      ),
    );
  }
}

class ViewFileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyFilesScreen();
  }
}

class ViewLinkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyLinksScreen();
  }
}
