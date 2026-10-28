import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Whether the VPN is connected (UI state only; there is no VPN backend yet).
final connectedProvider = NotifierProvider<Connected, bool>(Connected.new);

class Connected extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
