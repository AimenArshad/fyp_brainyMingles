import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:brainy_mingles/view/resource_management/view_files.dart';
import 'package:brainy_mingles/view/resource_management/view_links.dart';

class AllResourcesPage extends StatefulWidget {
  const AllResourcesPage({super.key});

  @override
  State<AllResourcesPage> createState() => _AllResourcesPageState();
}

class _AllResourcesPageState extends State<AllResourcesPage> {
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
                      Icon(Icons.insert_drive_file),
                      SizedBox(width: 5),
                      Text('View Files'),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.link),
                      SizedBox(width: 5),
                      Text('View Links'),
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
    return FileListScreen();
  }
}

class ViewLinkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinkListScreen();
  }
}
