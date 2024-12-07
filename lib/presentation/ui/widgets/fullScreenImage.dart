import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis/presentation/ui/screens/homeScreen.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({super.key});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  void initState() {
    super.initState();

    // Navigate to another page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Get.to(() => const Homescreen(), transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 500),); // Replace YourTargetScreen with the screen you want to navigate to
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/open.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
