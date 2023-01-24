import 'package:camera/camera.dart';
import 'package:dog_breed_detection/ads_services/ads_services.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/fontsmanager.dart';
import 'package:dog_breed_detection/riverpod/detection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import '../resources/sizeconfig.dart';

class Communication extends ConsumerStatefulWidget {
  const Communication({Key? key}) : super(key: key);

  @override
  ConsumerState<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends ConsumerState<Communication> {
  bool imgfile = false;
  CameraImage? imgcamera;
  bool _isCameraInitialized = false;
  CameraController? controller;
  late CameraDescription cameraDescription;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _isCameraInitialized = controller!.value.isInitialized;
      cameraController.startImageStream((imagestream) => {
            if (!ref.read(notifierProvider.notifier).isWorking)
              {
                ref.read(notifierProvider.notifier).isWorking = true,
                imgcamera = imagestream,
                ref.read(notifierProvider.notifier).runModelonFrame(imgcamera)
              }
          });
    });
    // Update the Boolean
  }

  final notifierProvider = ChangeNotifierProvider<ImageNotifier>((ref) {
    return ImageNotifier();
  });

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    ref.read(notifierProvider.notifier).loaddatamodel();
    onNewCameraSelected(cameras[0]);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller != null
          ? controller!.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
    if (state == AppLifecycleState.inactive) {
      controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller!.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  nameDisplay(val) {
    if (val == null) {
      return "Nothing to Scan";
    } else if (val == '') {
      return "Scanning      ";
    } else {
      String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
      return capitalize(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        // AdsServices.displayInterstitialAds();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _isCameraInitialized
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: CameraPreview(controller!),
                      );
                    },
                  )
                : Container(),
            Positioned(
              top: 10,
              left: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // AdsServices.displayInterstitialAds();
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width * 0.11,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.white.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorManager.primary,
                      ),
                    )),
              ),
            ), //Container

            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              right: 0,
              left: 0,
              child: Center(
                  child: Lottie.asset('assets/images/circle_scanning.json')),
            ),
            Positioned(
              bottom: 130,
              left: 0,
              right: 0,
              child: Center(
                child: nameDisplay(ref.watch(notifierProvider).liveresult) !=
                            "Scanning      " &&
                        nameDisplay(ref.watch(notifierProvider).liveresult) !=
                            "Nothing to Scan"
                    ? Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.7,
                        // height: MediaQuery.of(context).size.height * 0.08,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green.withOpacity(0.6)),
                        child: Text(
                          nameDisplay(ref.watch(notifierProvider).liveresult),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s24,
                              fontWeight: FontWeightManager.bold),
                          overflow: TextOverflow.fade,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: nameDisplay(ref
                                        .watch(notifierProvider)
                                        .liveresult) !=
                                    "Nothing to Scan"
                                ? ColorManager.primary.withOpacity(0.6)
                                : Colors.yellow.withOpacity(0.8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  nameDisplay(
                                      ref.watch(notifierProvider).liveresult),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s24,
                                      fontWeight: FontWeightManager.bold),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                            nameDisplay(ref
                                        .watch(notifierProvider)
                                        .liveresult) !=
                                    "Nothing to Scan"
                                ? LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.white,
                                    size: FontSize.s24,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
              ),
            ), //Container
            //Container
          ], //<Widget>[]
        ),
      ),
    );
  }
}
