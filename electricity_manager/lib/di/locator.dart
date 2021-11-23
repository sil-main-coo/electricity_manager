import 'package:electricity_manager/app_bloc/app_bloc.dart';
import 'package:electricity_manager/data/local/authen_local_provider.dart';
import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/data/remote/device_remote_provider.dart';
import 'package:electricity_manager/data/remote/resolve_report_remote_provider.dart';
import 'package:electricity_manager/data/remote/take_back_report_remote_provider.dart';
import 'package:electricity_manager/utils/helpers/firebase/firebase_db_helpers.dart';
import 'package:electricity_manager/utils/helpers/firebase/firebase_storage_helper.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:electricity_manager/utils/helpers/session/shared_pref_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

GetIt getIt = GetIt.instance;

void locator() {
  // external
  getIt.registerSingleton(SharedPreferencesManager());
  getIt.registerSingleton(ImagePickerHelper(picker: ImagePicker()));

  // remote source
  getIt.registerSingleton(FirebaseStorageHelpers());
  getIt.registerSingleton(FirebaseDBHelpers());
  getIt.registerFactory(() => AuthRemoteProvider());
  getIt.registerSingleton(DeviceRemoteProvider());
  getIt.registerFactory(() => TakeBackReportRemoteProvider());
  getIt.registerFactory(() => ResolveReportRemoteProvider());

  // local source
  getIt.registerFactory<AuthenLocalProvider>(() => AuthenLocalProvider());

  // bloc
  getIt.registerLazySingleton<AppBloc>(() => AppBloc(getIt()));
}
