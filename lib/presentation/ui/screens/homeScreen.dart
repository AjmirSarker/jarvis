import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/main.dart';
import 'package:tflite/tflite.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isWorking = false;
  String result = "Loading model...";
  CameraController? cameraController;
  CameraImage? imgCamera;

  // Load the TFLite model
  loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/tf/mobilenet_v1_1.0_224.tflite',
        labels: 'assets/tf/mobilenet_v1_1.0_224.txt',
      );
      setState(() {
        result = "Model Loaded, Camera Ready!";
      });
    } catch (e) {
      setState(() {
        result = "Model loading failed: $e";
      });
    }
  }

  // Initialize the camera and start the image stream
  initCamera() {
    cameraController = CameraController(
      cameras![0], // Use the first available camera
      ResolutionPreset.medium,
    );
    cameraController?.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        // Start streaming the camera images
        cameraController?.startImageStream((imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = imageFromStream;
            runModelOnStreamFrames(); // Call the model to process the frame
          }
        });
      });
    }).catchError((e) {
      setState(() {
        result = "Camera initialization failed: $e";
      });
    });
  }

  // Process each frame with the loaded model
  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      String newResult = "Recognitions:\n";
      if (recognitions != null) {
        for (var response in recognitions) {
          newResult += "${response["label"]} ${(response["confidence"] as double).toStringAsFixed(2)}\n\n";
        }
      } else {
        newResult += "No recognitions detected.";
      }

      setState(() {
        result = newResult; // Update the UI with the recognition results
      });
      isWorking = false; // Allow processing of the next frame
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel(); // Load the model on start
  }

  @override
  void dispose() {
    Tflite.close(); // Close the model when disposing of the screen
    cameraController?.dispose(); // Dispose the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Camera and Model Inference'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width - 10,
                      child: Image.asset('assets/images/camera.jpg'),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        initCamera();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 35),
                        color: Colors.transparent,
                        height: 270,
                        width: MediaQuery.of(context).size.width - 10,
                        child: imgCamera == null
                            ? Container(
                                height: 270,
                                width: MediaQuery.of(context).size.width - 10,
                                child: Icon(
                                  Icons.photo_camera_front,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              )
                            : AspectRatio(
                                aspectRatio:
                                    cameraController!.value.aspectRatio,
                                child: CameraPreview(cameraController!),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 55),
                  child: SingleChildScrollView(
                    child: Text(
                      result,
                      style: TextStyle(
                        backgroundColor: Colors.black87,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
