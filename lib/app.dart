import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis/controller_binder.dart';

import 'package:jarvis/presentation/ui/widgets/fullScreenImage.dart';

class JARVIS extends StatefulWidget {
  const JARVIS({super.key});

  @override
  State<JARVIS> createState() => _JARVISState();
}

class _JARVISState extends State<JARVIS> {
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SafeArea(child:  FullScreenImage()),
      initialBinding: ControllerBinder(),
    );
  }
}