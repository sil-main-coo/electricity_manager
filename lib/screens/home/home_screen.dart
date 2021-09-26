import 'package:electricity_manager/commons/text_styles.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/create_electricity_info/create_electricity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý biên bản',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: _bodyHome(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => CreateElectricityScreen())),
        label: 'Tạo mới',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _bodyHome() {
    return LayoutHaveFloatingButton(
      child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) => _item(index),
          separatorBuilder: (_, __) => Divider(),
          itemCount: 20),
    );
  }

  Widget _item(int index) {
    final titleStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);

    return ListTile(
      leading: Icon(Icons.event_note),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(style: titleStyle, text: 'Mã KH: ', children: [
            TextSpan(text: '${index.toString()}', style: titleStyle)
          ])),
          RichText(
              text: TextSpan(style: titleStyle, text: 'Tên KH: ', children: [
            TextSpan(
                text: 'TRƯƠNG VIỆT HOÀNG',
                style: titleStyle.copyWith(color: Colors.blue))
          ])),
        ],
      ),
      subtitle: Text(
          'Đ/c: Số 10 ngõ 53 đường Tân Triều, Tân Triều, Thanh Trì, Hà Nội'),
    );
  }
}
