import 'package:electricity_manager/screens/components/dialogs/loading_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_bloc/app_bloc.dart';
import 'app_bloc/bloc.dart';
import 'data/remote/auth_remote_provider.dart';
import 'di/locator.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/bloc/login_bloc.dart';
import 'screens/login/login.dart';
import 'utils/helpers/firebase/firebase_storage_helper.dart';

/// có 3 hướng:
/// - html -> content -> replace -> convert to word
/// - word -> html -> content -> replace -> convert to word
/// - word -> api convert -> word
///

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  locator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
            create: (context) => getIt<AppBloc>()
              ..add(
                AppStarted(),
              )),
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
                appBloc: getIt<AppBloc>(),
                authRemoteProvider: getIt<AuthRemoteProvider>())),
      ],
      child: ScreenUtilInit(
        designSize: Size(411.4, 843.4),
        builder: () => GestureDetector(
          onTap: () {
            FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {
                if (state is AppLoading) {
                  LoadingDialog.show(context, '');
                } else if (state is HideAppLoading) {
                  LoadingDialog.hide(context);
                }
              },
              builder: (context, state) {
                if (state is AppAuthenticated) {
                  return _buildHomeScreen();
                }
                if (state is AppUnauthenticated) {
                  return LoginPage();
                }
                return Scaffold(
                  body: Center(
                    child: const CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return FutureBuilder(
      future: getIt.get<FirebaseStorageHelpers>().getReportTemplate(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error');
        }

        if (snapshot.hasData) {
          return HomeScreen();
        }

        return Scaffold(
          body: Center(
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
