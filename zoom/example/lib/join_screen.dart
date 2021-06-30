import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoom/zoom.dart';

class JoinWidget extends StatefulWidget {
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();
  Timer timer;

  @override
  void initState() {
    meetingIdController.text = "92133699727";
    meetingPasswordController.text = "111";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: Text('Join meeting'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    controller: meetingIdController,
                    decoration: InputDecoration(
                      labelText: 'Meeting ID',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    controller: meetingPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Meeting Password',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return RaisedButton(
                      // If onPressed is null, the button is disabled
                      // this is my goto temporary callback.
                      onPressed: () => joinMeeting(context),
                      child: Text('Join'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return RaisedButton(
                      // If onPressed is null, the button is disabled
                      // this is my goto temporary callback.
                      onPressed: () => startMeeting(context),
                      child: Text('Start Meeting'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid)
      return status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    return status == "MEETING_STATUS_ENDED";
  }

  joinMeeting(BuildContext context) {
    ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
      //https://jwt.io/
      //--todo from server
      jwtToken:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiJLN0N3R09DOUJhbG5IU2lxVm1kcGhUZUw4aE9RRUhZUGpjUFYiLCJpYXQiOjE2MTU1MTA3OTksImV4cCI6MTY0NzAxNzk5OSwidG9rZW5FeHAiOjE2NDcwMTc5OTl9.qxNdVZpK5PwDDbinyU4A-pYC1eBmTykayZFRNnuiUu0",
    );
    var meetingOptions = new ZoomMeetingOptions(
        userId: 'example',
        meetingId: meetingIdController.text,
        meetingPassword: meetingPasswordController.text,
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false");
    var zoom = Zoom();
    zoom.init(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStateChanged.listen((status) {
          print("Meeting Status Stream: " + status[0] + " - " + status[1]);
          if (_isMeetingEnded(status[0])) {
            timer?.cancel();
          }
        });
        zoom.onMeetingMinimizeStateChanged.listen((isMinimize) {
          if (isMinimize) {
            print("Meeting is Minimize");
          } else {
            print("Meeting is Full Screen");
          }
        });
        zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
          timer = Timer.periodic(new Duration(seconds: 2), (timer) {
            zoom.meetingStatus(meetingOptions.meetingId).then((status) {
              print("Meeting Status Polling: " + status[0] + " - " + status[1]);
            });
          });
        });
      }
    });
  }

  startMeeting(BuildContext context) {}
}
