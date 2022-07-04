import 'package:flutter/foundation.dart';

class ShareData extends ChangeNotifier {
  String? _vOwner;
  String? _vName;
  String? _vDes;
  String? _vUrl;

  void sharingData(String vOwner, String vName, String vDes, String vUrl) {
    _vOwner = vOwner;
    _vName = vName;
    _vDes = vDes;
    _vUrl = vUrl;
    notifyListeners();
  }

  String? get vOwner => _vOwner;
  String? get vName => _vName;
  String? get vDes => _vDes;
  String? get vUrl => _vUrl;
}
