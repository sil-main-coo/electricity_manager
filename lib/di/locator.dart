import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:electricity_manager/utils/helpers/session/shared_pref_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

GetIt getIt = GetIt.instance;

void locator() {
  getIt.registerSingleton(SharedPreferencesManager());
  getIt.registerSingleton(ImagePickerHelper(picker: ImagePicker()));
}
