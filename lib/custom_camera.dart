import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:customkamera/widgets/custom_outlined_button.dart';
import 'package:customkamera/widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'commons/common.dart';

class CustomCameraLayout extends StatefulWidget {
  @override
  _CustomCameraLayoutState createState() => _CustomCameraLayoutState();
}

class _CustomCameraLayoutState extends State<CustomCameraLayout>
    with WidgetsBindingObserver {
  Offset? _tapPosition;

  String code = "";
  String info = "";
  String error_name = "";

  List<CameraDescription> cameras = [];
  String? imagePath;
  CameraController? controller;
  String? base64ImageSelfie;

  @override
  void initState() {
    getCameras();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      getCameras();
    }
  }

  void getCameras() async {
    cameras = await availableCameras();
    cameras.forEach((camera) {
      if (camera.lensDirection == CameraLensDirection.back) {
        onCameraSelected(camera);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                    padding: EdgeInsets.only(right: 0.0, left: 0.0),
                    child: ListView(children: <Widget>[
                      SizedBox(height: 16.0),
                      _textCameraAbsensi(),
                      SizedBox(height: 16.0),
                      Container(
                        height: 520,
                        child: Stack(
                          children: <Widget>[
                            imagePath != null
                                ? capturedImageWidget(imagePath!)
                                : _cameraPreviewWidget(),
                            imagePath != null
                                ? Container()
                                : Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              gridview_camera_assets),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                            imagePath == null
                                ? statusInfo(context)
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.0),
                      imagePath != null
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: InkWell(
                                  onTap: () {
                                    _captureImage();
                                  },
                                  child: Image.asset(
                                    shoot_button_assets,
                                    width: 80,
                                    height: 80,
                                  ))),
                      imagePath == null
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: CustomOutlinedButton(
                                text: "FOTO ULANG",
                                textColor: primaryColor,
                                color: primaryColor,
                                width: double.infinity,
                                onPressed: () {
                                  setState(() {
                                    imagePath = null;
                                    base64ImageSelfie = null;
                                  });
                                },
                              ),
                            ),
                      imagePath == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 16.0),
                              child: CustomRaisedButton(
                                "UNGGAH FOTO",
                                color: [primaryColor, primaryColor],
                                textColor: secondaryColor,
                                width: double.infinity,
                                onPressed: () {},
                              ),
                            ),
                    ])),
              ),
              GestureDetector(
                onTapDown: (details) {
                  _tapPosition = details.globalPosition;
                  _handleFocus();
                },
                child: Container(
                  width: double.infinity,
                  height: 520,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statusInfo(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1.0, color: secondaryColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 8.0),
              transform: Matrix4.translationValues(0, 2, 0),
              child: const Icon(
                Icons.info,
                color: blacktitleColor,
                size: 20,
              ),
            ),
            Expanded(
                child: RichText(
                    text: TextSpan(
                        text:
                            'Posisikan barcode dan angka stand berada di dalam bingkai seperti contoh ini.',
                        style: mediumBlackFont.copyWith(
                          fontSize: 13,
                          letterSpacing: 0.75,
                          color: blacktitleColor,
                        ),
                        children: []))),
          ],
        ),
      ),
    );
  }

  Widget noImageWidget() {
    return SizedBox.expand(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Icon(
            Icons.image,
            color: Colors.grey,
          ),
          width: 60.0,
          height: 60.0,
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          child: const Text(
            'No Image Captured',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ));
  }

  Widget capturedImageWidget(String imagePath) {
    return SizedBox.expand(
      child: Image.file(
        File(
          imagePath,
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _textCameraAbsensi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Center(
              child: Text(
                'Semangat UAT nya :)',
                textAlign: TextAlign.center,
                style: semiWhiteFont.copyWith(
                  fontSize: 12,
                  letterSpacing: 0.75,
                  color: dialogtextColor,
                ),
              ),
            )),
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container(
          width: double.infinity,
          height: 520,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                'Fitur camera belum muncul.',
                style: semiBlackFont.copyWith(
                  color: validationColor,
                  fontSize: 18,
                ),
              )));
    } else {
      return Container(
        width: double.infinity,
        height: 520,
        child: AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CameraPreview(controller!)),
      );
    }
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller?.dispose();
    //old
    // controller = CameraController(cameraDescription, ResolutionPreset.medium);

    //new
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller?.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        showMessage('Camera Error: ${controller?.value.errorDescription}');
      }
    });

    try {
      await controller?.initialize();
    } on CameraException catch (e) {
      showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void _captureImage() {
    takePicture().then((String? filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          showMessage('Picture saved to $filePath');
          setCameraResult();
        }
      }
    });
  }

  void setCameraResult() {
    File test4 = new File(imagePath!);
    List<int> imageBytes = test4.readAsBytesSync();
    base64ImageSelfie = base64Encode(imageBytes);
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      showMessage('Error: select a camera first.');
      return null;
    }

    String? filePath;

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      await controller?.takePicture().then((XFile? file) {
        if (mounted) {
          setState(() {
            filePath = file?.path;
          });
        }
      });
    } on CameraException catch (e) {
      showException(e);
      return null;
    }
    return filePath;
  }

  void showException(CameraException e) {
    logError(e.code, e.description.toString());
    showMessage('Error: ${e.code}\n${e.description}');
  }

  void showMessage(String message) {
    print(message);
  }

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');

  void _handleFocus() {
    if (_tapPosition == null || controller == null || !controller!.value.isInitialized) {
      return;
    }

    final Size screenSize = MediaQuery.of(context).size;
    final double x = _tapPosition!.dx / screenSize.width;
    final double y = _tapPosition!.dy / screenSize.height;

    final FocusMode focusMode = _calculateFocusMode(x, y);

    controller!.setFocusMode(focusMode);
  }

  FocusMode _calculateFocusMode(double x, double y) {
    return FocusMode.auto;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
