import 'dart:math' as math;
// // Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

final String localUserID = math.Random().nextInt(10000).toString();

/// Users who use the same callID can in the same call.
const String callID = "group_call_id";
var conferenceDTextCtrl1 = TextEditingController();

class VideoCall extends StatelessWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Users who use the same conferenceID can in the same conference.
  var conferenceDTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.video_call,
                size: 100,
                color: Colors.blue[900],
              ),
              // const SizedBox(height: 10),
              // Image.asset(
              // "images/logo1rb.png",
              // ),
              // Padding(
              // padding: const EdgeInsets.only(top: 1), // Adjust the top padding as needed
              // child: Image.asset(
              //   "images/logo1rb.png",
              // ),
              // ),

              Text(
                "Join Video Call",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              // Padding(
              // padding: const EdgeInsets.only(top: 10), // Adjust the top padding as needed
              // child: Text(
              //   "Join Video Call",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     color: Colors.blue[900],
              //   ),
              // ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: conferenceDTextCtrl1,
                      decoration:
                          const InputDecoration(labelText: "Enter Name"),
                          
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: conferenceDTextCtrl,
                      decoration: const InputDecoration(
                          labelText: "Join a conference by id"),
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) {
                  //           return VideoConferencePage(
                  //             conferenceID: conferenceDTextCtrl.text,
                  //           );
                  //         }),
                  //       );
                  //     },
                  //     child: const Text("join"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return VideoConferencePage(
                              conferenceID: conferenceDTextCtrl.text,
                            );
                          }),
                        );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Join Meeting"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 30),
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
          ),
        )
                  //  ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) {
                  //           return VideoConferencePage(
                  //             conferenceID: conferenceDTextCtrl.text,
                  //           );
                  //         }),
                  //       );
                  //     },
                  //     child: const Text("join"))
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;

  const VideoConferencePage({
    Key? key,
    required this.conferenceID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 806368859,
        appSign:
            "5c8deed1726b1c810dd46be2cac5e8a2b3cb0efae78b87885709c5039d4382d6",
        userID: localUserID,
        userName: conferenceDTextCtrl1.text,
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}