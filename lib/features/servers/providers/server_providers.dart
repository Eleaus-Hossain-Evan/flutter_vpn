import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The server the user picked; Home shows it once connected.
final selectedServerProvider = NotifierProvider<SelectedServer, String>(
  SelectedServer.new,
);

class SelectedServer extends Notifier<String> {
  @override
  String build() => 'us-ny';

  void select(String id) => state = id;
}

/// Starred server ids, shared by Choose server and Server details.
final favoritesProvider = NotifierProvider<Favorites, Set<String>>(
  Favorites.new,
);

class Favorites extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {'us-ny'};

  /// Returns whether [id] is now a favourite.
  bool toggle(String id) {
    final added = !state.contains(id);
    state = added ? {...state, id} : ({...state}..remove(id));
    return added;
  }
}
