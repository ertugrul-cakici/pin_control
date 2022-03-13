import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_control/core/init/cache/locale_manager.dart';
import 'package:pin_control/view/home/view/home.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow();
  await windowManager.setAlwaysOnTop(false);
  await windowManager.setClosable(false);
  await windowManager.maximize();
  await LocaleManager.preferencesInit();
  // SerialManager.connect();
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: () {
        return MaterialApp(
          theme: ThemeData.dark(),
          home: const Home(),
        );
      },
    );
  }
}
