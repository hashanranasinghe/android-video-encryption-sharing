import 'package:flutter/foundation.dart';

class ShareData extends ChangeNotifier {
  String? _vOwner;
  String? _vName;
  String? _vDes;
  String? _vUrl;
  String? _vKey;
  String? _vSize;

  void sharingData(String vOwner, String vName, String vDes, String vUrl,
      String vKey, String vSize) {
    _vOwner = vOwner;
    _vName = vName;
    _vDes = vDes;
    _vUrl = vUrl;
    _vKey = vKey;
    _vSize = vSize;
    notifyListeners();
  }

  String? get vOwner => _vOwner;
  String? get vName => _vName;
  String? get vDes => _vDes;
  String? get vUrl => _vUrl;
  String? get vKey => _vKey;
  String? get vSize => _vSize;
}
