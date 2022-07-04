class CreateAccDetails {
  String? uid;
  String? userName;
  String? email;

  CreateAccDetails({this.uid, this.userName, this.email});

  //receiving data from server
  factory CreateAccDetails.fromMap(map) {
    return CreateAccDetails(
      uid: map['uid'],
      userName: map['userName'],
      email: map['email'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
    };
  }
}
