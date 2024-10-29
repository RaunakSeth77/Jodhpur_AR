import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class StateModel extends ChangeNotifier {
  bool _isSceneLoaded = false;
  String? _selectedTarget;
  double _yOffset = 0.0;
  bool _lineVisible = true;
  bool _isRequestingPermissions = false;

  bool get isSceneLoaded => _isSceneLoaded;
  String? get selectedTarget => _selectedTarget;
  double get yOffset => _yOffset;
  bool get lineVisible => _lineVisible;

  void setSceneLoaded(bool value) {
    _isSceneLoaded = value;
    notifyListeners();
  }

  void setSelectedTarget(String value) {
    _selectedTarget = value;
    notifyListeners();
  }

  void setYOffset(double value) {
    _yOffset = value;
    notifyListeners();
  }

  void toggleLineVisibility() {
    _lineVisible = !_lineVisible;
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    if (_isRequestingPermissions) return;
    _isRequestingPermissions = true;
    try {
      await [
        Permission.location,
        Permission.camera,
        Permission.storage,
      ].request();
    } finally {
      _isRequestingPermissions = false;
      notifyListeners();
    }
  }
}