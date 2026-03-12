import 'package:flutter/widgets.dart';
import 'package:flutter_app_fila_certa/app/settings_controller.dart';

class SettingsScope extends InheritedNotifier<SettingsController> {
  final SettingsController controller;

  const SettingsScope({
    super.key,
    required this.controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static SettingsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'SettingsScope não encontrado no contexto.');
    return scope!.controller;
  }

  // Acesso sem se registrar como dependente
  static SettingsController read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<SettingsScope>();
    final widget = element?.widget as SettingsScope?;
    assert(widget != null, 'SettingsScope não encontrado no contexto.');
    return widget!.controller;
  }
}