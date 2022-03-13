import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_control/product/model/pin_model.dart';
import 'package:pin_control/core/init/providers/all_providers.dart';

// ignore: must_be_immutable
class PinButton extends ConsumerWidget {
  final int index;
  PinButton({Key? key, required this.index}) : super(key: key);
  late PinModel _pinModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _pinModel = ref.read(homeProvider).pinModels[index];
    ChangeNotifierProvider<PinModel> _pinProvider =
        ChangeNotifierProvider((ref) => _pinModel);
    return InkWell(
      onTap: ref.read(_pinProvider).active,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, width: 1, style: BorderStyle.solid),
          color: ref.watch(_pinProvider).isActive ? Colors.red : Colors.black12,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ref.read(_pinProvider).text),
              Checkbox(
                  checkColor: Colors.red,
                  value: ref.watch(_pinProvider).isSelected,
                  onChanged: (bool? state) {
                    if (ref.watch(_pinProvider).isSelected) {
                      ref.read(_pinProvider).unselect();
                      ref.read(homeProvider).removePinFromQueue(_pinModel.pin);
                    } else {
                      ref.read(_pinProvider).select();
                      ref.read(homeProvider).addPinToQueue(_pinModel.pin);
                    }
                  }),
              Text(ref.watch(homeProvider).selectedPins.contains(_pinModel)
                  ? "Sıra: ${ref.watch(homeProvider).selectedPins.indexOf(_pinModel) + 1}"
                  : ""),
            ],
          ),
        ),
      ),
    );
  }
}
