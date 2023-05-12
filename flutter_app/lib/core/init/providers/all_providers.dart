import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_control/view/home/home_notifier.dart';

final ChangeNotifierProvider<HomeNotifier> homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());
