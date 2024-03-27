import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Report {
  final String id;
  final String email;
  final int reportCount;
  final List<Map<String, String>> reports;

  Report(
      {required this.id,
      required this.email,
      required this.reportCount,
      required this.reports});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      email: json['email'],
      reportCount: json['reportCount'],
      reports: List<Map<String, String>>.from(json['reports'].map((report) => {
            'reportedBy': report['reportedBy']
                .toString(), // Ensure 'reportedBy' is a String
            'reason':
                report['reason'].toString(), // Ensure 'reason' is a String
          })),
    );
  }
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchReports() async {
    try {
      final String? token = await retrieveToken();
      final response = await http.get(
        Uri.parse('http://192.168.10.25:4200/api/reports/get-reports'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          reports = jsonResponse.map((data) => Report.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (error) {
      print('Error fetching reports: $error');
    }
  }

  void handleBlock(BuildContext context, String reportId) async {
    // Show a dialog box to confirm the action
    bool confirmAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Block'),
          content: Text('Are you sure you want to block this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    // If user confirms the action, send the reportId to the backend
    if (confirmAction == true) {
      print('Blocking user with report ID: $reportId');
      final String? token = await retrieveToken();
      final response = await http.post(
        Uri.parse(
            'http://192.168.10.25:4200/api/reports/block-report/$reportId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Report deleted successfully');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('User has been blocked'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          reports.removeWhere((report) => report.id == reportId);
        });
      } else {
        print('Failed to delete the report');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to block the user'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FacultyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          Padding(
            padding: EdgeInsets.all(17.0),
            child: Text(
              'List of Reports',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 2.0), // Increased border width
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.blueColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(), // Empty SizedBox for alignment
                            PopupMenuButton(
                              icon:
                                  Icon(Icons.info_outline, color: Colors.white),
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: Icon(Icons.block),
                                      title: Text('Block'),
                                      onTap: () {
                                        String reportId = reports[index].id;
                                        Navigator.of(context).pop();
                                        // Call the function to handle the block action
                                        handleBlock(context, reportId);
                                      },
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/profile.jpeg",
                                  width: 65,
                                  height: 80,
                                ),
                                SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reports[index].email,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.blueColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                        'Report Count: ${reports[index].reportCount}'),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            ExpansionTile(
                              title: Text('Reports'),
                              textColor: AppColor.blueColor,
                              children: [
                                for (var report in reports[index].reports)
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 25.0, bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Reason: ${report['reason']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'Reported by: ${report['reportedBy']}'),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
