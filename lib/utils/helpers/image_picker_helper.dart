import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  ImagePickerHelper({required this.picker});

  final ImagePicker picker;

  Future<XFile?> imgFromCamera() async {
    return await picker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
  }

  Future<XFile?> imgFromGallery() async {
    return await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
  }
}