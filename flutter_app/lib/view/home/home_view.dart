import "package:flutter/material.dart";
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_control/core/init/providers/all_providers.dart';
import 'package:pin_control/view/home/pin_button.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeView> {
  @override
  void initState() {
    ref.read(homeProvider).generatePinModels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ScreenUtil().uiSize.width * 0.5,
          ),
          child: GridView.count(
              crossAxisCount: 5,
              crossAxisSpacing: 25.w,
              mainAxisSpacing: 25.w,
              shrinkWrap: true,
              children: [
                ...List.generate(12, (index) => PinButton(index: index)),
                const SizedBox(),
                const SizedBox(),
                const SizedBox(),
                _screenManager(),
                _activeMultiple(),
                _activeQueue(),
                TimeSettings(),
                Text("Active ports:" + SerialPort.availablePorts.toString())
              ]),
        ),
      ),
    ));
  }

  Widget _screenManager() {
    return Consumer(
      builder: (context, _, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Do not close the screen"),
            Checkbox(
                value: _.watch(homeProvider).screenState,
                onChanged: _.read(homeProvider).changeScreenState)
          ],
        );
      },
    );
  }

  Widget _activeMultiple() {
    return InkWell(
      onTap: ref.read(homeProvider).activeMultiple,
      child: Container(
          color: Colors.black12,
          child: const Center(child: Text("Run multiple"))),
    );
  }

  Widget _activeQueue() {
    return InkWell(
      onTap: ref.read(homeProvider).activeQueue,
      child: Container(
          color: Colors.black12,
          child: const Center(child: Text("Work queue"))),
    );
  }
}

class TimeSettings extends ConsumerWidget {
  TimeSettings({Key? key}) : super(key: key);

  final TextEditingController _delayController = TextEditingController();
  final TextEditingController _activeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _delayController.text = ref.watch(homeProvider).delayTime.toString();
    _activeController.text = ref.watch(homeProvider).activeTime.toString();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
              controller: _delayController,
              onChanged: ref.read(homeProvider).setDelayTime,
              decoration: const InputDecoration(labelText: "Delay (ms)")),
          TextField(
              controller: _activeController,
              onChanged: ref.read(homeProvider).setActiveTime,
              decoration:
                  const InputDecoration(labelText: "Working time (ms)")),
        ],
      ),
    );
  }
}
