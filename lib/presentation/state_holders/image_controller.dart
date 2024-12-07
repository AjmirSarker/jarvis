import 'package:get/get.dart';

class ImageController  extends GetxController {
bool _isPasswordVisible = false; 
bool get passwordVisible => _isPasswordVisible;
void changePasswordView(){
  _isPasswordVisible = !_isPasswordVisible; //
  update();
}


}