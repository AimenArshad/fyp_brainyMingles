import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LinkUploadScreen extends StatefulWidget {
  @override
  _LinkUploadScreenState createState() => _LinkUploadScreenState();
}

class _LinkUploadScreenState extends State<LinkUploadScreen> {
  bool _isButtonEnabled = false;
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _topicNameController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _altTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _courseNameController.addListener(_checkButtonState);
    _topicNameController.addListener(_checkButtonState);
    _linkController.addListener(_checkButtonState);
    _altTextController.addListener(_checkButtonState);
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _courseNameController.text.isNotEmpty &&
          _topicNameController.text.isNotEmpty &&
          _linkController.text.isNotEmpty &&
          _altTextController.text.isNotEmpty;
    });
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _uploadLink() async {
    final String? token = await retrieveToken();
    if (token != null) {
      final url = Uri.parse('http://192.168.10.25:4200/api/links/upload-link');
      final Map<String, String> data = {
        'url': _linkController.text,
        'altText': _altTextController.text,
        'course': _courseNameController.text,
        'topic': _topicNameController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          print('Link uploaded successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Link uploaded successfully'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Failed to upload link ${response.statusCode}');
        }
      } catch (error) {
        print('Error uploading link: $error');
      }
    } else {
      print("token not provided");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child: TextField(
                controller: _linkController,
                maxLines: null,
                style: TextStyle(color: Color.fromARGB(255, 0, 93, 168)),
                decoration: InputDecoration(
                  labelText: 'Link',
                  labelStyle: TextStyle(
                    color: AppColor.blueColor,
                  ),
                  contentPadding: EdgeInsets.only(bottom: -2.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child: TextField(
                controller: _altTextController,
                maxLines: null,
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: 'Alt Text(Max 15 Characters)',
                  labelStyle: TextStyle(
                    color: AppColor.blueColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Set border color
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child: TextField(
                controller: _courseNameController,
                maxLength: 30,
                maxLines: null, // Allow multiple lines
                decoration: InputDecoration(
                  labelText: 'Course Name (Max 30 Characters)',
                  labelStyle: TextStyle(
                    color: AppColor.blueColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Set border color
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child: TextField(
                controller: _topicNameController,
                maxLength: 100,
                maxLines: null, // Allow multiple lines
                decoration: InputDecoration(
                  labelText: 'Topic Name (Max 100 Characters)',
                  labelStyle: TextStyle(
                    color: AppColor.blueColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _uploadLink : null,
              child: Text('Upload Link'),
              style: _isButtonEnabled
                  ? ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          AppColor.blueColor, // Text color when enabled
                      padding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      ), // Set blue color when enabled
                    )
                  : ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey, // Text color when disabled
                      padding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _topicNameController.dispose();
    _linkController.dispose();
    _altTextController.dispose();

    super.dispose();
  }
}
