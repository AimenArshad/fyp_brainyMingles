import 'dart:io';
import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  bool _isButtonEnabled = false;
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _topicNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _courseNameController.addListener(_checkButtonState);
    _topicNameController.addListener(_checkButtonState);
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _courseNameController.text.isNotEmpty &&
          _topicNameController.text.isNotEmpty &&
          _selectedFile != null;
    });
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
      _checkButtonState();
    }
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _uploadFile() async {
    final String? token = await retrieveToken();
    if (token != null) {
      if (_selectedFile != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.10.25:4200/api/file/upload-file'),
        );
        request.files.add(
            await http.MultipartFile.fromPath('file', _selectedFile!.path));
        request.fields['course'] = _courseNameController.text;
        request.fields['topic'] = _topicNameController.text;
        request.headers["Authorization"] = "Bearer $token";
        var response = await request.send();
        if (response.statusCode == 200) {
          print('File uploaded successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('File uploaded successfully'),
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
          print('Failed to upload file');
        }
      }
    } else {
      print("No token available");
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
            MyButton(
              width: 100,
              height: 50,
              onTap: _selectFile,
              text: "Select File",
            ),
            SizedBox(height: 20),
            _selectedFile != null
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _getIconForFileExtension(_selectedFile!.path
                            .split('/')
                            .last), // Icon based on file extension
                        SizedBox(width: 10), // Add space between icon and text
                        Flexible(
                          flex: 1, // Allow it to take up remaining space
                          child: Text(
                            _selectedFile!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
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
              onPressed: _isButtonEnabled ? _uploadFile : null,
              child: Text('Upload File'),
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
    super.dispose();
  }
}

Icon _getIconForFileExtension(String fileName) {
  String extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Icon(Icons.picture_as_pdf, color: AppColor.blueColor);
    case 'doc':
    case 'docx':
      return Icon(Icons.description, color: AppColor.blueColor);
    case 'jpg':
    case 'jpeg':
    case 'png':
      return Icon(Icons.image, color: AppColor.blueColor);
    case 'mp4':
    case 'avi':
    case 'mkv':
      return Icon(Icons.videocam, color: AppColor.blueColor);
    default:
      return Icon(Icons.insert_drive_file, color: AppColor.blueColor);
  }
}
