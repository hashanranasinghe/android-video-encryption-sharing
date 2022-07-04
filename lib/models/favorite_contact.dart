class FavoriteContact {
  String? uid;
  String? contactName;
  String? contactEmail;

  FavoriteContact({this.uid, this.contactName, this.contactEmail});

  //receiving data from server
  factory FavoriteContact.fromMap(map) {
    return FavoriteContact(
      uid: map['uid'],
      contactName: map['contactName'],
      contactEmail: map['contactEmail'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'contactName': contactName,
      'contactEmail': contactEmail,
    };
  }
}
