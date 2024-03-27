import 'dart:convert';
import 'dart:io';
import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({Key? key}) : super(key: key);

  @override
  _MyFilesScreenState createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  late List<MyFile> files = [];
  List<MyFile> displayedFiles = [];
  static const platform = MethodChannel(
      'com.example.androidstorage.android_12_flutter_storage/storage');
  String mProgress = "";
  String? selectedFileType;
  String? courseFilter;
  String? topicFilter;
  bool filtersApplied = false;

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  Future<void> requestStoragePermission() async {
    try {
      await platform.invokeMethod('requestStoragePermission');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchFiles() async {
    final String? token = await retrieveToken();
    final response = await http.get(
      Uri.parse('http://192.168.10.25:4200/api/file/get-myfiles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );

    final List<dynamic> jsonData = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        files = jsonData.map((e) => MyFile.fromJson(e)).toList();
        displayedFiles = files;
      });
    }
  }

  Future<void> openFile(String id) async {
    final String? token = await retrieveToken();
    final response = await http.get(
      Uri.parse('http://192.168.10.25:4200/api/file/open-file/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );
    final jsonData = jsonDecode(response.body);
    final fileData = jsonData['data'];
    final filename = jsonData['name'];

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);
    await file.writeAsBytes(base64Decode(fileData));

    final OpenResult result = await OpenFile.open(filePath);
    if (result.type == ResultType.done) {
      print("File Opened Successfully");
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to open the file.'),
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

  List<MyFile> getFilteredFiles() {
    List<MyFile> filteredFiles = [...files];
    if (selectedFileType != null) {
      filteredFiles = filteredFiles
          .where((file) => file.name.toLowerCase().endsWith(selectedFileType!))
          .toList();
    }
    if (courseFilter != null && courseFilter!.isNotEmpty) {
      filteredFiles = filteredFiles
          .where((file) =>
              file.course.toLowerCase().contains(courseFilter!.toLowerCase()))
          .toList();
    }
    if (topicFilter != null && topicFilter!.isNotEmpty) {
      filteredFiles = filteredFiles
          .where((file) =>
              file.topic.toLowerCase().contains(topicFilter!.toLowerCase()))
          .toList();
    }
    return filteredFiles;
  }

  Future<void> downloadFile(String id, String filename) async {
    final String? token = await retrieveToken();
    requestStoragePermission();
    final response = await http.get(
      Uri.parse('http://192.168.10.25:4200/api/file/open-file/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );
    final jsonData = jsonDecode(response.body);
    final fileData = jsonData['data'];
    List<int> bytes = base64Decode(fileData);
    String path = await _getFilePath(filename);
    // Write bytes to file
    await File(path).writeAsBytes(bytes);
  }

  Future<void> deleteFile(String id) async {
    final String? token = await retrieveToken();
    final response = await http.delete(
      Uri.parse('http://192.168.10.25:4200/api/file/delete-file/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print('File deleted successfully');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('File Deleted Successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        displayedFiles.removeWhere((file) => file.id == id);
      });
    } else {
      print('Failed to delete the file');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete the file.'),
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

  Future<String> _getFilePath(String fileName) async {
    var dir = Directory('/storage/emulated/0/Download/BrainyMingles');
    final filePath = '${dir.path}/$fileName';
    print("File Name: $filePath");
    try {
      platform.invokeMethod('saveFile', {'path': filePath});
      print("file saved successfully");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('File downloaded successfully'),
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
    } on PlatformException catch (e) {
      print(e);
    }
    return filePath;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: selectedFileType,
                        onChanged: (String? value) {
                          setState(() {
                            if (value == 'none') {
                              selectedFileType = null;
                            } else {
                              selectedFileType = value;
                            }
                            filtersApplied = true;
                          });
                        },
                        items: [
                          'none',
                          'jpg',
                          'jpeg',
                          'png',
                          'doc',
                          'docx',
                          'pdf',
                          'mp4',
                          'avi',
                          'mkv',
                          'ppt',
                          'pptx',
                          'xls',
                          'xlsx'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Select file type'),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey), // Apply border on all sides
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: add border radius
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter course name',
                        border:
                            InputBorder.none, // Remove default TextField border
                      ),
                      onChanged: (value) {
                        setState(() {
                          courseFilter = value;
                          filtersApplied = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey), // Apply border on all sides
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: add border radius
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter topic name',
                        border:
                            InputBorder.none, // Remove default TextField border
                      ),
                      onChanged: (value) {
                        setState(() {
                          topicFilter = value;
                          filtersApplied = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                padding:
                    const EdgeInsets.only(top: 15.0, right: 15.0, left: 15),
                child: Center(
                  child: MyButton(
                    width: 100,
                    height: 40,
                    onTap: () {
                      setState(() {
                        filtersApplied = true;
                        displayedFiles =
                            filtersApplied ? getFilteredFiles() : files;
                      });
                    },
                    text: "Apply All",
                  ),
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.all(1.0),
                child: Center(
                  child: MyButton(
                    width: 100,
                    height: 40,
                    onTap: () {
                      setState(() {
                        filtersApplied = false;
                        displayedFiles =
                            filtersApplied ? getFilteredFiles() : files;
                      });
                    },
                    text: 'Remove All',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: displayedFiles.isNotEmpty
          ? ListView.builder(
              // itemCount: files.length,
              itemCount: displayedFiles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    border: Border.all(
                      color: Colors.black, // Set border color
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => openFile(displayedFiles[index].id),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    _getIconForFileType(
                                        displayedFiles[index].name),
                                    color: AppColor.blueColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      displayedFiles[index].name,
                                      maxLines: displayedFiles[index].expanded
                                          ? null
                                          : 1,
                                      overflow: displayedFiles[index].expanded
                                          ? null
                                          : TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                displayedFiles[index].expanded =
                                    !displayedFiles[index].expanded;
                              });
                            },
                            icon: Icon(
                              displayedFiles[index].expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColor.blueColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10, left: 45),
                        child: Text(
                          'course: ${displayedFiles[index].course}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (displayedFiles[index].expanded)
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 45),
                          child: Row(
                            children: [
                              Expanded(
                                // Add Expanded widget here
                                child: Text(
                                  'topic: ${displayedFiles[index].topic}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => downloadFile(
                                        displayedFiles[index].id,
                                        displayedFiles[index].name),
                                    icon: Icon(
                                      Icons.download,
                                      color: AppColor.blueColor,
                                    ),
                                    iconSize: 25,
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        deleteFile(displayedFiles[index].id),
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColor.blueColor,
                                    ),
                                    iconSize: 25,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (displayedFiles[index].expanded) SizedBox(height: 10),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'Files are displayed here...',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
    );
  }

  IconData _getIconForFileType(String fileName) {
    if (fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png')) {
      return Icons.image;
    } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
      return Icons.description;
    } else if (fileName.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (fileName.endsWith('.mp4') ||
        fileName.endsWith('.avi') ||
        fileName.endsWith('.mkv')) {
      return Icons.videocam;
    } else if (fileName.endsWith('.ppt') || fileName.endsWith('.pptx')) {
      return Icons.slideshow; // Icon for PowerPoint files
    } else if (fileName.endsWith('.xls') || fileName.endsWith('.xlsx')) {
      return Icons.insert_chart; // Icon for Excel files
    } else {
      return Icons.insert_drive_file;
    }
  }
}

class MyFile {
  final String id;
  final String name;
  final String course;
  final String topic;
  bool expanded;

  MyFile({
    required this.id,
    required this.name,
    required this.course,
    required this.topic,
    this.expanded = false,
  });

  factory MyFile.fromJson(Map<String, dynamic> json) {
    return MyFile(
      id: json['_id'],
      name: json['name'],
      course: json['course'],
      topic: json['topic'],
    );
  }
}
