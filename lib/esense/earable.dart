import 'package:esense_flutter/esense.dart';

class Earable {

  static const String _DEVICE_NAME = 'eSense-1588';

  bool _isConnected = false;

  Future<void> connect() async {
    if (!_isConnected) {
      _isConnected = await ESenseManager().connect(_DEVICE_NAME);
    }
    print('$_isConnected');
  }

  Future<void> disconnect() async {
    Future<bool> future = ESenseManager().disconnect();
    future.then((connected) => _isConnected = !connected);
  }

  bool isConnected() {
    return _isConnected;
  }
}