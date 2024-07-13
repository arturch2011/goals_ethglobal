import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goals_ethglobal/screens/preview_screen.dart';

class CameraApp extends StatefulWidget {
  final int index;
  const CameraApp({super.key, required this.index});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  bool isCameraInitialized = false;
  bool isFlashOn = false;
  XFile? capturedImage; // Armazenará a imagem capturada

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);

    try {
      await controller.initialize();
      if (!mounted) {
        return;
      }
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
      controller.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  void takePicture(indexs) async {
    try {
      final file = await controller.takePicture();
      setState(() {
        capturedImage = file; // Armazena a imagem capturada
      });
      if (isFlashOn) {
        controller.setFlashMode(FlashMode.off);
        isFlashOn = false;
      }
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ImagePreviewScreen(
                imagePath: capturedImage!.path, index: indexs);
          },
        ),
      );
    } catch (e) {
      print("Erro ao capturar a foto: $e");
    }
  }

  void switchCamera() async {
    if (controller.value.isInitialized) {
      final lensDirection = controller.description.lensDirection;
      CameraDescription newCamera;
      final cameras = await availableCameras();
      if (lensDirection == CameraLensDirection.back) {
        newCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);
      } else {
        newCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);
      }
      await controller.dispose();
      controller = CameraController(newCamera, ResolutionPreset.max);
      await controller.initialize();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    if (!isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: CameraPreview(controller)),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.white.withOpacity(0.4), // Fundo semitransparente
                  ),
                  child: InkWell(
                    onTap: toggleFlash,
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/flash.svg',
                          width: 27, height: 27),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5), // Borda semitransparente
                      width: 8,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => takePicture(index),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.white.withOpacity(0.4), // Fundo semitransparente
                  ),
                  child: InkWell(
                    onTap: switchCamera,
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/reload.svg',
                          width: 27, height: 27),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
