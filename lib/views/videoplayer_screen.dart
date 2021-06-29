import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yellowcase_app/controller/video_controller.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  CameraController? cameraController;
  late List<CameraDescription> _cameras;
  VideoScreenController videoController = Get.put(VideoScreenController());

  double get screenHeight => MediaQuery.of(context).size.height;

  double get screenWidth => MediaQuery.of(context).size.width;

  Offset position = Offset(650, 230);

  void updatePosition(Offset newPosition) {
    print('newpos' + newPosition.toString());
    print('height ' + screenHeight.toString());
    print('width ' + screenWidth.toString());
    setState(() => position = newPosition);
  }

  @override
  void initState() {
    _initCamera();
    // updatePosition(Offset(screenHeight*.85, screenWidth*.67));
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    cameraController = CameraController(_cameras[1], ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    print('height ' + screenHeight.toString());
    print('width ' + screenWidth.toString());
    if (cameraController != null) {
      if (!cameraController!.value.isInitialized) {
        return Container(child: Center(child: Text("No Camera available")));
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!cameraController!.value.isInitialized) {
      return Container(child: Center(child: Text("No Camera available")));
    }
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Obx(
        () {
          if (!videoController.isLoading.value)
            return Stack(
              fit: StackFit.expand,
              children: [
                videoController.videoPlayerController.value.isInitialized
                    ? SizedBox(
                        height: _size.height,
                        width: _size.width,
                        child:
                            VideoPlayer(videoController.videoPlayerController))
                    : Container(),
                Positioned(
                  bottom: _size.height / 20,
                  child: Row(
                    children: [
                      Obx(() => IconButton(
                            onPressed: () {
                              videoController.onPlayButtonclick();
                            },
                            icon: Icon(
                              videoController.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            color: Colors.red,
                            iconSize: 45,
                          )),
                      Obx(() => IconButton(
                          onPressed: () {
                            videoController.onMuteClick();
                          },
                          icon: Icon(videoController.isMute.value
                              ? Icons.volume_off
                              : Icons.volume_up),
                          color: Colors.red,
                          iconSize: 45)),
                      Obx(() => Slider(
                            min: 0,
                            max: 1,
                            activeColor: Colors.red,
                            value: videoController.sound.toDouble(),
                            onChanged: (value) {
                              videoController.sound.value = value;
                              print(videoController.sound.value);
                              videoController.videoPlayerController
                                  .setVolume(videoController.sound.value);
                            },
                          )),
                    ],
                  ),
                ),
                Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: Draggable(
                    maxSimultaneousDrags: 1,
                    feedback: dragObject(),
                    childWhenDragging: Opacity(
                      opacity: .3,
                      child: dragObject(),
                    ),
                    onDragEnd: (details) => updatePosition(details.offset),
                    child: dragObject(),
                  ),
                ),
              ],
            );
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget dragObject() {
    return RotatedBox(
      quarterTurns: 2,
      child: Container(
          height: 120,
          width: 90,
          color: Colors.black,
          child: CameraPreview(cameraController!)),
    );
  }
}
