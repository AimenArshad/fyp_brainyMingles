// import 'package:brainy_mingles/const/app_colors.dart';
// import 'package:brainy_mingles/const/sizedbox_extension.dart';
// import 'package:brainy_mingles/view/dashboard/dashboard_widgets.dart';
// import 'package:brainy_mingles/widgets/custom_appbar.dart';
// import 'package:brainy_mingles/widgets/custom_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardView extends StatefulWidget {
//   const DashboardView({super.key});

//   @override
//   State<DashboardView> createState() => _DashboardViewState();
// }

// class _DashboardViewState extends State<DashboardView> {
//   String? authToken;

//   @override
//   void initState() {
//     super.initState();
//     _loadAuthToken();
//   }

//   Future<String?> retrieveToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<void> _loadAuthToken() async {
//     final token = await retrieveToken();
//     setState(() {
//       authToken = token;
//     });
//     print("Token: $token");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: FacultyDrawer(),
//       body: Column(
//         children: [
//           CustomAppBar(),
//           16.h.sbh,
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.symmetric(horizontal: 13.w),
//               children: [
//                 Center(
//                   child: Text(
//                     'Dashboard',
//                     style: TextStyle(
//                       color: AppColor.blueColor,
//                       fontSize: 20.sp,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 15.h.sbh,
//                 DashboardInfoBox(
//                     boxName: "School",
//                     imageAddress: "assets/student.png",
//                     name: "Usman",
//                     email: "usmanmuaz@gmail.com",
//                     phoneNo: "0300XXXXXXX",
//                     gender: "2022",
//                     status: "Current"),
//                 // DashboardInfoBox(
//                 //     boxName: "Interest",
//                 //     imageAddress: "assets/interest.png",
//                 //     name: "Usman",
//                 //     email: "usmanmuaz@gmail.com",
//                 //     phoneNo: "0300XXXXXXX",
//                 //     degree: "BSCS",
//                 //     batch: "2022",
//                 //     status: "Current"),
//                 // DashboardInfoBox(
//                 //     boxName: "Sessions",
//                 //     imageAddress: "assets/sessions.png",
//                 //     name: "Usman",
//                 //     email: "usmanmuaz@gmail.com",
//                 //     phoneNo: "0300XXXXXXX",
//                 //     degree: "BSCS",
//                 //     batch: "2022",
//                 //     status: "Current"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/dashboard/dashboard_widgets.dart';
import 'package:brainy_mingles/view/dashboard/studentdashboardwidget.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String? authToken;
  Map<String, dynamic>? studentDetails;

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
    _fetchStudentDetails();
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _loadAuthToken() async {
    final token = await retrieveToken();
    setState(() {
      authToken = token;
    });
  }

  Future<void> _fetchStudentDetails() async {
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:4200/api/student/mydetails'),
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        );
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            studentDetails = responseData;
          });
        } else {
          throw Exception('Failed to fetch student details');
        }
      } catch (error) {
        print('Error fetching student details: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentDrawer(),
      body: Column(
        children: [
          CustomAppBar(),
          16.h.sbh,
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              children: [
                Center(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      color: AppColor.blueColor,
                      fontSize: 20.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                15.h.sbh,
                if (studentDetails != null) ...[
                  DashboardInfoBox(
                    boxName: 'School',
                    imageAddress: 'assets/student.png',
                    name: studentDetails!['name'],
                    email: studentDetails!['email'],
                    phoneNo: studentDetails!['phoneNumber'],
                    gender: studentDetails!['gender'],
                    status: 'Current',
                  ),
                  StudentInfoBox(
                    boxName: 'Languages',
                    imageAddress: 'assets/student.png',
                    languages: (studentDetails!['languages'] as List<dynamic>)
                        .map((language) => language['name'] as String)
                        .toList(),
                    levels: (studentDetails!['languages'] as List<dynamic>)
                        .map((language) => language['difficultyLevel'] as int)
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
