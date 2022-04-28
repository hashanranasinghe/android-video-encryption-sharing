import 'dart:io';
import 'dart:typed_data';
import'package:encrypt/encrypt.dart' as enc;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/firebasefile.dart';

class FirebaseApi {

  // static UploadTask? uploadFile(String destination, File file) {
  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination);
  //     return ref.putFile(file);
  //   } on FirebaseException catch (e) {
  //     return null;
  //   }
  // }

  //uploading
  static UploadTask? uploadBytes(String destination,Uint8List data ) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      var result= _encryptedData(data);

        return ref.putData(result);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  //encrypting
  static _encryptedData(data){
    print("Encrypting....");
    final entrypted = Encryption.myEncrypter.encryptBytes( data, iv: Encryption.myIv);
    return entrypted.bytes;
  }

  //listing
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name: name, url: url);

      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  // static Future downloadFile(Reference ref) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/${ref.name}');
  //   print('${dir.path}');
  //
  //   await ref.writeToFile(file);
  // }

  //downloading location
  Future<Directory?> get getAppDir async{
    final appDocDir = await getExternalStorageDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async{
    if(await Directory('/storage/emulated/0/SecureVideoFolder').exists()){
      final externalDir = Directory('/storage/emulated/0/SecureVideoFolder');
      return externalDir;
    }else{
      await Directory('/storage/emulated/0/SecureVideoFolder')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/SecureVideoFolder');
      return externalDir;
    }
  }

  //downloading
  static getNormalFile(Directory d,fileName,file) async{
    Uint8List encData = await _readData(fileName);
    var plainData = await decryptedData(encData);



    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(fileName);

    var match = matches.elementAt(0);
    var vName = Uri.decodeFull(match.group(2)!);
    print("${Uri.decodeFull(match.group(2)!)}");

    var pos = vName.lastIndexOf('.');
    var st = vName.indexOf('.');
    String last = (pos != -1)? vName.substring(st, pos): vName;
    print('$last');

    String p = await _writeData(plainData,d.path + '/$file' + last);

  }

  //reading bytes of video file before downloading
  static Future<Uint8List> _readData(fileName) async{
    print("reading............");
    // File f = File(fileNameWithPath);
    // return await f.readAsBytes();
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(fileName))
        .load(fileName))
        .buffer
        .asUint8List();
    return bytes;
  }

  //write data in the location
  static Future<String> _writeData(dataToWrite,fileNameWithPath) async{
    print("writing............");
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataToWrite);
    return f.absolute.toString();
  }


  //decrypting
  static decryptedData(encData){
    print('decrypting............');
    enc.Encrypted en = new enc.Encrypted(encData);
    return Encryption.myEncrypter.decryptBytes(en, iv: Encryption.myIv);
  }

}


//encryption class
class Encryption{
  static final myKey = enc.Key.fromUtf8('HashanRanasingheHashanRanasinghe');
  static final myIv = enc.IV.fromUtf8('SabraSabra202022');
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
}
