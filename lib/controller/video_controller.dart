import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';

class VideoScreenController extends GetxController {
late  AgoraClient client;
late  VideoPlayerController videoPlayerController;
  var sound = 0.7.obs;
  var isPlaying = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    initializeVideoPlayer();
    initializeCameraFeed();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    videoPlayerController.dispose();
    resetOrientation();
  }

  Future initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4');
    await Future.wait([videoPlayerController.initialize()]);

    videoPlayerController.setLooping(true);
    
    setLandscape();
    update();
  }

  void onPlayButtonclick() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController.play();
        isPlaying.value=true;
    }
  }

  void initializeCameraFeed() {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "b55391ea6e0e4a9b8860129bd1b2ee41",
        channelName: "test",
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );
    update();
  }

  Future setLandscape() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  Future resetOrientation() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}
