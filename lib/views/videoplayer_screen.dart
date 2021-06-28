import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yellowcase_app/controller/video_controller.dart';


class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
        body: GetBuilder<VideoScreenController>(
            init: VideoScreenController(),
            builder: (controller) => Stack(
                  fit: StackFit.expand,
                  children: [
                    controller.videoPlayerController.value.isInitialized
                        ? SizedBox(
                            /*  height: _size.height*.5,
                      width: _size.width*.5, */
                            child:
                                VideoPlayer(controller.videoPlayerController))
                        : Container(),
                    Positioned(
                      bottom: _size.height / 20,
                      child: Row(
                        children: [
                          Obx(() => IconButton(
                              onPressed: () {
                                // videoPlayerController.setVolume(10);
                                controller.onPlayButtonclick();
                              },
                              icon: Icon(
                                controller.isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ))),
                          IconButton(
                              onPressed: () {
                                /*  videoPlayerController.play(); */
                              },
                              icon: Icon(Icons.volume_up)),
                          Obx(() => Slider(
                                min: 0,
                                max: 1,
                                value: controller.sound.toDouble(),
                                onChanged: (value) {
                                  controller.sound.value = value;
                                  print(controller.sound.value);
                                  controller.videoPlayerController
                                      .setVolume(controller.sound.value);
                                },
                              )),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: _size.height / 20,
                      right: _size.height / 20,
                      child: Container(
                        height: 120,
                        width: 90,
                        child: AgoraVideoViewer(client: controller.client),
                      ),
                    ),
                  ],
                )));
  }
}
