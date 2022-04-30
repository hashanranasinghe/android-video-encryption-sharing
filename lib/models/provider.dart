import 'package:flutter/foundation.dart';

class ShareData extends ChangeNotifier{

  String? _vName;
  String? _vDes;
  String? _vUrl;

  void sharingData(String vName,String vDes, String vUrl){
    _vName = vName;
    _vDes = vDes;
    _vUrl = vUrl;
    notifyListeners();
  }
  String? get vName => _vName;
  String? get vDes => _vDes;
  String? get vUrl => _vUrl;

}

