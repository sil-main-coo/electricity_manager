import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'di/locator.dart';
import 'screens/home/home_screen.dart';
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
    return ScreenUtilInit(
      designSize: Size(411.4, 843.4),
      builder: () =>
          GestureDetector(
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
                home: FutureBuilder(
                  future: getIt.get<FirebaseStorageHelpers>()
                      .getReportTemplate(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('error');
                    }

                    if (snapshot.hasData) {
                      return HomeScreen();
                    }

                    return Scaffold(
                      body: Center(child: const CircularProgressIndicator(),),);
                  },
                )
            ),
          ),
    );
  }
}
