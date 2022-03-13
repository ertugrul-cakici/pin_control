import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_control/view/home/viewmodel/home_view_model.dart';

final ChangeNotifierProvider<HomeViewModel> homeProvider =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());
