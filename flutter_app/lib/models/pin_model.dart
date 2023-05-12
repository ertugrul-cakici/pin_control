import "package:flutter/material.dart";
import 'package:pin_control/core/constants/enums/locale_constants.dart';
import 'package:pin_control/core/init/cache/locale_manager.dart';
import 'package:pin_control/core/init/serial/serial_manager.dart';
import 'package:pin_control/view/home/home_notifier.dart';

class PinModel extends ChangeNotifier {
  bool isSelected = false;
  bool isActive = false;
  final int pin;

  String get pinText => pin > 10 ? pin.toString() : "0$pin";
  String text;

  PinModel({required this.pin, required this.text});

  Future<void> active() async {
    if (HomeNotifier.activePins.length < 2) {
      bool success = await send("${pinText}O");
      if (success) {
        isActive = true;
        HomeNotifier.activePins.add(this);
        notifyListeners();

        int _time = LocaleManager.instance.getInt(LocaleEnums.activeTime.name);
        await Future.delayed(Duration(milliseconds: _time));
        deactive();
      }
    }
  }

  Future<void> deactive() async {
    bool success = await send("${pinText}C");
    if (success) {
      isActive = false;
      HomeNotifier.activePins.remove(this);
      notifyListeners();
    }
  }

  void select() {
    isSelected = true;
    notifyListeners();
  }

  void unselect() {
    isSelected = false;
    notifyListeners();
  }

  Future<bool> send(String cmd) async {
    bool success = SerialManager.sendCMD(cmd);
    if (success) {
      return true;
    } else {
      while (!SerialManager.isConnected) {
        SerialManager.connect();
        await Future.delayed(const Duration(seconds: 1));
      }
      return false;
    }
  }
}
