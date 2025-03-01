// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async'; 
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zoom_platform_interface/zoom_options.dart';

import 'method_channel_zoom.dart';
export 'zoom_options.dart';
abstract class ZoomPlatform extends PlatformInterface {
  ZoomPlatform() : super(token: _token);
  static final Object _token = Object();
  static ZoomPlatform _instance = MethodChannelZoom();
  static ZoomPlatform get instance => _instance;
  static set instance(ZoomPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  Future<List> initZoom(ZoomOptions options) async {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  Future<bool> startMeeting(ZoomMeetingOptions options) async {
    throw UnimplementedError('startMeeting() has not been implemented.');
  }

  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    throw UnimplementedError('joinMeeting() has not been implemented.');
  }

  Future<List> meetingStatus(String meetingId) async {
    throw UnimplementedError('meetingStatus() has not been implemented.');
  }

  Stream<dynamic> onMeetingStatus(){
    throw UnimplementedError('onMeetingStatus() has not been implemented.');
  }

  Stream<dynamic> onMeetingMinimizeStatus(){
    throw UnimplementedError('onMeetingMinimizeStatus() has not been implemented.');
  }
}
