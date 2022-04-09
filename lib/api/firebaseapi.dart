import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import'package:encrypt/encrypt.dart' as enc;

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {

  // static UploadTask? uploadFile(String destination, File file) {
  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination);
  //     return ref.putFile(file);
  //   } on FirebaseException catch (e) {
  //     return null;
  //   }
  // }


  static UploadTask? uploadBytes(String destination,Uint8List data ) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      var result= _encryptedData(data);

        return ref.putData(result);


    } on FirebaseException catch (e) {
      return null;
    }
  }
  static _encryptedData(data){
    print("Encrypting....");
    final entrypted = Encryption.myEncrypter.encryptBytes( data, iv: Encryption.myIv);
    return entrypted.bytes;
  }
}


class Encryption{
  static final myKey = enc.Key.fromUtf8('HashanRanasingheHashanRanasinghe');
  static final myIv = enc.IV.fromUtf8('SabraSabra202022');
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
}
