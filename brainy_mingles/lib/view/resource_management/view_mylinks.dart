import 'dart:convert';
import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyLinksScreen extends StatefulWidget {
  const MyLinksScreen({Key? key}) : super(key: key);

  @override
  _MyLinksScreenState createState() => _MyLinksScreenState();
}

class _MyLinksScreenState extends State<MyLinksScreen> {
  late List<MyLink> links = [];
  List<MyLink> displayedlinks = [];
  String? courseFilter;
  String? topicFilter;
  bool filtersApplied = false;

  @override
  void initState() {
    super.initState();
    fetchLinks();
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchLinks() async {
    if (!mounted) return;
    final String? token = await retrieveToken();
    try {
      final response = await http.get(
        Uri.parse('http://192.168.10.25:4200/api/links/get-mylinks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (!mounted) return;
      setState(() {
        links = jsonData.map((e) => MyLink.fromJson(e)).toList();
        displayedlinks = links;
      });
    } catch (error) {
      print('Error fetching links: $error');
      // Handle error
    }
  }

  Future<void> openLink(String url) async {
    print(url);
    final Uri _url = Uri.parse(url);
    print(_url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  List<MyLink> getFilteredLinks() {
    List<MyLink> filtereLinks = [...links];
    if (courseFilter != null && courseFilter!.isNotEmpty) {
      filtereLinks = filtereLinks
          .where((link) =>
              link.course.toLowerCase().contains(courseFilter!.toLowerCase()))
          .toList();
    }
    if (topicFilter != null && topicFilter!.isNotEmpty) {
      filtereLinks = filtereLinks
          .where((link) =>
              link.topic.toLowerCase().contains(topicFilter!.toLowerCase()))
          .toList();
    }
    return filtereLinks;
  }

  Future<void> deleteLink(String id) async {
    final String? token = await retrieveToken();
    final response = await http.delete(
      Uri.parse('http://192.168.10.25:4200/api/links/delete-link/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print('Link deleted successfully');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Link Deleted Successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        displayedlinks.removeWhere((link) => link.id == id);
      });
    } else {
      print('Failed to delete the link');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete the link.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) => [
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
                        displayedlinks =
                            filtersApplied ? getFilteredLinks() : links;
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
                        displayedlinks =
                            filtersApplied ? getFilteredLinks() : links;
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
      body: displayedlinks.isNotEmpty
          ? ListView.builder(
              itemCount: displayedlinks.length,
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
                              onTap: () => openLink(displayedlinks[index].url),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.link, // Use a link icon
                                    color: AppColor.blueColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      displayedlinks[index]
                                          .altText, // Display alt text
                                      maxLines: displayedlinks[index].expanded
                                          ? null
                                          : 1,
                                      overflow: displayedlinks[index].expanded
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
                                displayedlinks[index].expanded =
                                    !displayedlinks[index].expanded;
                              });
                            },
                            icon: Icon(
                              displayedlinks[index].expanded
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
                          'course: ${displayedlinks[index].course}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (displayedlinks[index].expanded)
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 45),
                          child: Row(
                            children: [
                              Expanded(
                                // Add Expanded widget here
                                child: Text(
                                  'topic: ${displayedlinks[index].topic}',
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
                                    onPressed: () =>
                                        deleteLink(displayedlinks[index].id),
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
                      if (displayedlinks[index].expanded) SizedBox(height: 10),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MyLink {
  final String id;
  final String altText;
  final String url;
  final String course;
  final String topic;
  bool expanded;

  MyLink({
    required this.id,
    required this.altText,
    required this.url,
    required this.course,
    required this.topic,
    this.expanded = false,
  });

  factory MyLink.fromJson(Map<String, dynamic> json) {
    return MyLink(
      id: json['_id'],
      altText: json['altText'],
      url: json['url'],
      course: json['course'],
      topic: json['topic'],
    );
  }
}
