// import 'package:electricity_manager/utils/commons/text_styles.dart';
// import 'package:electricity_manager/di/locator.dart';
// import 'package:electricity_manager/models/report_model.dart';
// import 'package:electricity_manager/screens/components/floating_button_widget.dart';
// import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
// import 'package:electricity_manager/screens/create_electricity_info/create_electricity_screen.dart';
// import 'package:electricity_manager/screens/detail_info/detail_info_sreen.dart';
// import 'package:electricity_manager/utils/helpers/firebase/firebase_db_helpers.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'drawer_widget.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<Event>(
//         stream: getIt.get<FirebaseDBHelpers>().streamData(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Đã xảy ra lỗi');
//           }
//           if (snapshot.hasData) {
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text(
//                   'Quản lý biên bản',
//                   style: titleWhite.copyWith(fontSize: 22.sp),
//                 ),
//                 centerTitle: true,
//               ),
//               body: snapshot.data!.snapshot.value != null
//                   ? _bodyHome(snapshot.data!.snapshot.value)
//                   : Center(
//                       child: Text('Danh sách trống. Hãy tạo biên bản mới'),
//                     ),
//               drawer: DrawerWidget(),
//               floatingActionButton: FloatingButtonWidget(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => CreateElectricityScreen())),
//                 label: 'Tạo mới',
//               ),
//               floatingActionButtonLocation:
//                   FloatingActionButtonLocation.centerFloat,
//             );
//           }
//           return Scaffold(
//             body: Center(
//               child: const CircularProgressIndicator(),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _bodyHome(value) {
//     List<ReportModel> result = [];
//     final Map reportData = value;
//
//     reportData.forEach((key, value) {
//       result.insert(0, ReportModel.fromJson(key.toString(), Map.from(value)));
//     });
//
//     return LayoutHaveFloatingButton(
//       child: ListView.separated(
//           shrinkWrap: true,
//           primary: false,
//           itemBuilder: (context, index) => _item(result[index]),
//           separatorBuilder: (_, __) => Divider(),
//           itemCount: result.length),
//     );
//   }
//
//   Widget _item(ReportModel data) {
//     final titleStyle = TextStyle(
//         fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);
//
//     return ListTile(
//       onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (_) => DetailInfoScreen(
//                     reportModel: data,
//                   ))),
//       leading: Icon(Icons.event_note),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RichText(
//               text: TextSpan(style: titleStyle, text: 'Mã KH: ', children: [
//             TextSpan(text: '${data.idKH.toString()}', style: titleStyle)
//           ])),
//           RichText(
//               text: TextSpan(style: titleStyle, text: 'Tên KH: ', children: [
//             TextSpan(
//                 text: data.tenKH,
//                 style: titleStyle.copyWith(color: Colors.blue))
//           ])),
//         ],
//       ),
//       subtitle: Text('Đ/c: ${data.diaChi}'),
//     );
//   }
// }
