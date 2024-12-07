

import 'package:get/get.dart';
import 'package:jarvis/presentation/state_holders/image_controller.dart';

class ControllerBinder extends Bindings  {

  @override
  void dependencies(){
  //  Get.put( Logger());
  Get.put(ImageController());



  }
}