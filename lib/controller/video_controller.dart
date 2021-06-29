import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';

class VideoScreenController extends GetxController {
  var isLoading = true.obs;
  late VideoPlayerController videoPlayerController;
  var sound = 0.7.obs;
  var isPlaying = false.obs;
  var isMute = false.obs;

  @override
  void onInit() {
    super.onInit();

    initializeVideoPlayer();
  }

  @override
  void onClose() {
    super.onClose();
    videoPlayerController.dispose();
    resetOrientation();
  }

  Future initializeVideoPlayer() async {
    try {
      videoPlayerController = VideoPlayerController.network(
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4');
      await Future.wait([videoPlayerController.initialize()]);
    } catch (error) {
      print('Error occured by $error');
    }
    isLoading.value = false;
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
      isPlaying.value = true;
    }
  }

  void onMuteClick() {
    if (!isMute.value) {
      videoPlayerController.setVolume(0);
      isMute.value = true;
    } else {
      videoPlayerController.setVolume(sound.value);
      isMute.value = false;
    }
  }

  Future setLandscape() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future resetOrientation() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}
