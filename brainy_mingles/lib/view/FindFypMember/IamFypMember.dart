// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:brainy_mingles/const/app_colors.dart';
// import 'package:brainy_mingles/const/sizedbox_extension.dart';
// import 'package:brainy_mingles/models/fyp_model.dart';
// import 'package:brainy_mingles/widgets/my_button.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class RegisterFyp extends StatefulWidget {
//   const RegisterFyp({Key? key}) : super(key: key);

//   @override
//   State<RegisterFyp> createState() => _RegisterFypState();
// }

// class _RegisterFypState extends State<RegisterFyp> {
//   List<String> skillsArray = [];
//   List<String> requirementsArray = [];
//   String? cgpa;
//   String? department;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           Container(
//             width: double.infinity,
//             child: Image.asset(
//               "assets/login_top_shape_2.png",
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'CGPA',
//                     hintText: 'Enter CGPA',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       cgpa = value;
//                     });
//                   },
//                 ),
//                 10.h.sbh,
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Department',
//                     hintText: 'Enter Department',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       department = value;
//                     });
//                   },
//                 ),
//                 10.h.sbh,
//                 Text(
//                   'Skills',
//                   style: TextStyle(
//                     color: AppColor.blueColor,
//                     fontSize: 20.sp,
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 10.h.sbh,
//                 Wrap(
//                   spacing: 10.w,
//                   children: FypModel().skills.map((skill) {
//                     return Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               if (skillsArray.contains(skill)) {
//                                 skillsArray.remove(skill);
//                               } else {
//                                 skillsArray.add(skill);
//                               }
//                             });
//                           },
//                           style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.resolveWith<Color>(
//                               (states) {
//                                 return skillsArray.contains(skill)
//                                     ? AppColor.blueColor
//                                     : const Color(0xFFD9D9D9);
//                               },
//                             ),
//                           ),
//                           child: Text(
//                             skill,
//                             style: TextStyle(
//                               color: skillsArray.contains(skill)
//                                   ? Colors.white
//                                   : const Color(0xFF313131),
//                               fontSize: 10.sp,
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//                 Text(
//                   'Requirements',
//                   style: TextStyle(
//                     color: AppColor.blueColor,
//                     fontSize: 20.sp,
//                     fontFamily: 'Urbanist',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 10.h.sbh,
//                 Wrap(
//                   spacing: 10.w,
//                   children: FypModel().requirements.map((requirement) {
//                     return Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               if (requirementsArray.contains(requirement)) {
//                                 requirementsArray.remove(requirement);
//                               } else {
//                                 requirementsArray.add(requirement);
//                               }
//                             });
//                           },
//                           style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.resolveWith<Color>(
//                               (states) {
//                                 return requirementsArray.contains(requirement)
//                                     ? AppColor.blueColor
//                                     : const Color(0xFFD9D9D9);
//                               },
//                             ),
//                           ),
//                           child: Text(
//                             requirement,
//                             style: TextStyle(
//                               color: requirementsArray.contains(requirement)
//                                   ? Colors.white
//                                   : const Color(0xFF313131),
//                               fontSize: 10.sp,
//                               fontFamily: 'Urbanist',
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
//                   child: Center(
//                     child: MyButton(
//                       width: 150,
//                       textSize: 13.sp,
//                       text: "Register",
//                       onTap: registerFyp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void registerFyp() async {
//     Future<String?> retrieveToken() async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       return prefs.getString('token');
//     }

//     if (cgpa == null ||
//         department == null ||
//         skillsArray.isEmpty ||
//         requirementsArray.isEmpty) {
//       // Validate if all required fields are filled
//       return;
//     }

//     // Prepare the data to be sent in the request body
//     Map<String, dynamic> requestBody = {
//       'cgpa': cgpa,
//       'department': department,
//       'skills': skillsArray,
//       'requirements': requirementsArray,
//     };

//     // Convert the request body to JSON format
//     String jsonBody = jsonEncode(requestBody);
//     final String? token = await retrieveToken();
//     print(token);
//     if (token != null) {
//       try {
//         // Make the API call
//         final response = await http.post(
//           Uri.parse('http://10.0.2.2:4200/api/student/fypstudent'),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             "Authorization": "Bearer $token",
//           },
//           body: jsonBody,
//         );

//         if (response.statusCode == 201) {
//           // Handle success
//           print('FYP registration successful');
//         } else {
//           // Handle error
//           print('Error: ${response.statusCode}');
//           print('Response body: ${response.body}');
//         }
//       } catch (e) {
//         // Handle network or other errors
//         print('Error: $e');
//       }
//     } else {
//       // Handle the case where the token is not available
//       print('Token not available');
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:brainy_mingles/view/FindFypMember/Screen2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String? cgpa;
  String? department;
  String? idea;

  @override
  void initState() {
    super.initState();
    retrieveSharedData();
  }

  Future<void> retrieveSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cgpa = prefs.getString('cgpa');
      department = prefs.getString('department');
      idea = prefs.getString('idea');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'CGPA',
              hintText: 'Enter CGPA',
            ),
            onChanged: (value) {
              setState(() {
                cgpa = value;
              });
            },
          ),
          SizedBox(height: 10.h),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Department',
              hintText: 'Enter Department',
            ),
            onChanged: (value) {
              setState(() {
                department = value;
              });
            },
          ),
          SizedBox(height: 10.h),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Idea',
              hintText: 'Enter Your Idea',
            ),
            onChanged: (value) {
              setState(() {
                idea = value;
              });
            },
          ),
          SizedBox(height: 20.h),
          MyButton(
            text: 'Next',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterFyp(
                    cgpa: cgpa,
                    department: department,
                    idea: idea,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
