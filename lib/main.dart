import 'package:chess/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: false,
      splitScreenMode: false,
      child: MaterialApp(
        title: 'Chess',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeView(),
      ),
    );
  }
}
