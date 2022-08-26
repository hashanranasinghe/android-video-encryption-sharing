class InviteContact {
  String? uid;
  String? senderUid;
  String? senderName;
  String? senderEmail;
  String? inviteContactName;
  String? inviteContactEmail;

  InviteContact(
      {this.uid,
      this.senderUid,
      this.senderName,
      this.senderEmail,
      this.inviteContactName,
      this.inviteContactEmail});

  //receiving data from server
  factory InviteContact.fromMap(map) {
    return InviteContact(
      uid: map['uid'],
      senderUid: map['senderUid'],
      senderName: map['senderName'],
      senderEmail: map['senderEmail'],
      inviteContactName: map['inviteContactName'],
      inviteContactEmail: map['inviteContactEmail'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'senderUid': senderUid,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'inviteContactName': inviteContactName,
      'inviteContactEmail': inviteContactEmail,
    };
  }
}
