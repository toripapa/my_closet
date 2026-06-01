import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_model.dart';

class SelectedMenuNotifier extends Notifier<String> {
  @override
  String build() => 'home';
  void select(String menu) {
    state = menu;
  }
}

final selectedMenuProvider = NotifierProvider<SelectedMenuNotifier, String>(
  SelectedMenuNotifier.new,
);
final submenuProvider = Provider<List<MenuItem>?>((ref) {
  final selected = ref.watch(selectedMenuProvider);
  return menuMap[selected];
});
