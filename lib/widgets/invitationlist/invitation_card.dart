import 'package:app/models/invitatecontact.dart';
import 'package:app/screens/invitationscreen.dart';
import 'package:app/widgets/invitationlist/invitation_card_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/favorite_contact.dart';

class InvitationCard extends StatefulWidget {
  final InviteContact _inviteContact;
  final index;

  InvitationCard(this.index, this._inviteContact);

  @override
  State<InvitationCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<InvitationCard> {
  bool isDownloading = false;
  bool isLoading = true;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return isLoading != false
        ? InvitationCardField(
            textName: "${widget._inviteContact.senderName}",
            acceptFunction: () {

              favoriteContact(
                      widget._inviteContact.senderUid,
                      widget._inviteContact.inviteContactName,
                      widget._inviteContact.inviteContactEmail)
                  .whenComplete(() => favoriteInviteReceiverContact(
                          widget._inviteContact.senderUid,
                          widget._inviteContact.senderName,
                          widget._inviteContact.senderEmail)
                      .whenComplete(
                          () => deleteInvitation(widget.index, context)));
            },
            deleteFunction: () {
              deleteInvitation(widget.index, context);
            },
          )
        : Container();
  }

  Future<String> favoriteContact(senderUid, contactName, contactEmail) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    FavoriteContact favoriteContact = FavoriteContact();
    User? user = _auth.currentUser;

    //writing all values
    favoriteContact.contactName = contactName;
    favoriteContact.contactEmail = contactEmail;
    favoriteContact.uid = user!.uid;

    users.doc(senderUid).collection('contacts').add(favoriteContact.toMap());
    Fluttertoast.showToast(msg: "Added favorite successfully.");
    return "success";
  }

  Future<String> favoriteInviteReceiverContact(
      senderUid, contactName, contactEmail) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    FavoriteContact favoriteContact = FavoriteContact();
    User? user = _auth.currentUser;

    //writing all values
    favoriteContact.contactName = contactName;
    favoriteContact.contactEmail = contactEmail;
    favoriteContact.uid = senderUid;

    users.doc(user!.uid).collection('contacts').add(favoriteContact.toMap());
    Fluttertoast.showToast(msg: "Added favorite successfully.");
    return "success";
  }

  Future deleteInvitation(index, context) async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('invitations')
        .get();

    // print(data.docs[index].id);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("invitations")
        .doc(data.docs[index].id)
        .delete()
        .whenComplete(() => Navigator.of(context)
            .pushReplacementNamed(InvitationScreen.routeName));
  }
}
