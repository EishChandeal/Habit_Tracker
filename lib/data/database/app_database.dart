import 'dart:io';
import '../../objectbox.g.dart';

class AppDatabase {
  static Store? _store;

  static Future<Store> openStore({String? directory}) async {
    if (_store != null) {
      return _store!;
    }

    final path = directory ??
        (await Directory.systemTemp.createTemp('objectbox_test')).path;

    _store = Store(
      getObjectBoxModel(),
      directory: path,
    );
    return _store!;
  }

  static Store get instance {
    final store = _store;
    if (store == null) {
      throw StateError('Store has not been opened. Call openStore() first.');
    }
    return store;
  }

  static void closeStore() {
    _store?.close();
    _store = null;
  }
}
