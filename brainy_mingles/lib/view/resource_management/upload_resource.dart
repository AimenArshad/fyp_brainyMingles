import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:brainy_mingles/view/resource_management/addfile.dart';
import 'package:brainy_mingles/view/resource_management/addlink.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
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
                      Text('Add File'), // File text
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
                      Text('Add Link'), // Link text
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
            _selectedIndex == 0 ? AddFileTab() : AddLinkTab(),
            _selectedIndex == 1 ? AddLinkTab() : AddFileTab(),
          ],
        ),
      ),
    );
  }
}

class AddFileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FileUploadScreen();
  }
}

class AddLinkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinkUploadScreen();
  }
}
